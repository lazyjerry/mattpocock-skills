#!/usr/bin/env bash

set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

ruby - "$repo_root" <<'RUBY'
require 'yaml'

repo_root = ARGV.fetch(0)
source_root = File.join(repo_root, 'skills')
target_root = File.join(repo_root, 'skills-tw')
errors = []

relative_files = lambda do |root|
  Dir.glob(File.join(root, '**', '*'), File::FNM_DOTMATCH)
    .select { |path| File.file?(path) }
    .map { |path| path.delete_prefix("#{root}/") }
    .sort
end

expected_targets = relative_files.call(source_root)
actual_targets = relative_files.call(target_root)

errors << "file set differs: expected #{expected_targets.length}, got #{actual_targets.length}" unless expected_targets == actual_targets

markdown_links = lambda do |text|
  text.scan(/(?<!!)\[[^\]]*\]\(([^)]+)\)/).flatten.map { |target| target.split(/\s+/, 2).first }
end

comparable_link = lambda do |target|
  target.match?(/\A(?:https?:|mailto:)/) ? target : target.split('#', 2).first
end

inline_code = lambda do |text|
  text.scan(/(?<!`)`([^`\n]+)`(?!`)/).flatten
end

structure_counts = lambda do |text|
  {
    headings: text.lines.count { |line| line.match?(/^#+\s/) },
    fences: text.lines.grep(/^\s*(?:```|~~~)/).map(&:strip),
    lists: text.lines.count { |line| line.match?(/^\s*(?:[-*+] |\d+\. )/) },
    tables: text.lines.count { |line| line.match?(/^\s*\|/) }
  }
end

expected_targets.each do |target_relative|
  target_path = File.join(target_root, target_relative)
  source_path = File.join(source_root, target_relative)

  target = File.read(target_path, encoding: 'UTF-8')
  source = File.read(source_path, encoding: 'UTF-8')

  errors << "empty file: #{target_relative}" if target.empty?
  errors << "trailing whitespace: #{target_relative}" if target.lines.any? { |line| line.match?(/[ \t]+$/) }

  case File.extname(target_path)
  when '.md'
    errors << "no Traditional Chinese: #{target_relative}" unless target.match?(/\p{Han}/)

    source_lines = source.lines.length
    target_lines = target.lines.length
    ratio = target_lines.fdiv([source_lines, 1].max)
    errors << "suspicious line-count ratio #{ratio.round(2)}: #{target_relative}" unless ratio.between?(0.5, 1.8)

    source_structure = structure_counts.call(source)
    target_structure = structure_counts.call(target)
    errors << "heading count changed: #{target_relative}" unless source_structure[:headings] == target_structure[:headings]
    errors << "code fences changed: #{target_relative}" unless source_structure[:fences] == target_structure[:fences]
    errors << "list item count changed: #{target_relative}" unless source_structure[:lists] == target_structure[:lists]
    errors << "table row count changed: #{target_relative}" unless source_structure[:tables] == target_structure[:tables]

    source_name = source[/^name:\s*(.+)$/, 1]
    target_name = target[/^name:\s*(.+)$/, 1]
    errors << "frontmatter name changed: #{target_relative}" unless source_name == target_name

    normalized_target = target.gsub('_避免使用_', '_Avoid_')
    errors << "inline code changed: #{target_relative}" unless inline_code.call(source).sort == inline_code.call(normalized_target).sort
    errors << "URLs changed: #{target_relative}" unless source.scan(%r{https?://[^\s)>]+}).sort == normalized_target.scan(%r{https?://[^\s)>]+}).sort
    source_links = markdown_links.call(source).map(&comparable_link)
    target_links = markdown_links.call(normalized_target).map(&comparable_link)
    errors << "Markdown link targets changed: #{target_relative}" unless source_links == target_links

    in_fence = false
    target.lines.each_with_index do |line, index|
      in_fence = !in_fence if line.lstrip.start_with?('```', '~~~')
      next if in_fence || line.match?(/\p{Han}/) || line.scan(/[A-Za-z]+/).length < 12
      next if line.match?(/^\s*(?:name|disable-model-invocation):/) || line.count('`') >= 2

      errors << "possible untranslated prose: #{target_relative}:#{index + 1}"
    end

    markdown_links.call(target).each do |link|
      link = link.delete_prefix('<').delete_suffix('>')
      next if link.empty? || link.start_with?('#') || link.match?(/\A(?:https?:|mailto:)/)

      local_path = link.split('#', 2).first
      next if local_path.empty?
      resolved = File.expand_path(local_path, File.dirname(target_path))
      source_resolved = File.expand_path(local_path, File.dirname(source_path))
      errors << "broken local link #{link}: #{target_relative}" if File.exist?(source_resolved) && !File.exist?(resolved)
    end
  when '.yaml'
    begin
      source_yaml = YAML.safe_load(source)
      target_yaml = YAML.safe_load(target)
      errors << "YAML top-level keys changed: #{target_relative}" unless source_yaml.keys == target_yaml.keys
      errors << "YAML policy changed: #{target_relative}" unless source_yaml['policy'] == target_yaml['policy']

      display_name = target_yaml.dig('interface', 'display_name')
      short_description = target_yaml.dig('interface', 'short_description')
      errors << "missing YAML display_name: #{target_relative}" unless display_name.is_a?(String) && !display_name.empty?
      errors << "missing translated YAML short_description: #{target_relative}" unless short_description.is_a?(String) && short_description.match?(/\p{Han}/)
    rescue Psych::SyntaxError => error
      errors << "invalid YAML #{target_relative}: #{error.message.lines.first.strip}"
    end
  else
    errors << "non-document file changed: #{target_relative}" unless source == target
  end
end

all_text = expected_targets
  .select { |relative| %w[.md .yaml].include?(File.extname(relative)) }
  .map { |relative| File.read(File.join(target_root, relative), encoding: 'UTF-8') }
  .join("\n")

errors << 'em dash remains' if all_text.include?([0x2014].pack('U'))
errors << 'Simplified Chinese characters remain' if all_text.match?(/[这们发后与从还进应问开关统术该让读写录线务级类组处实验设计划标签页项软夹预创运户网据质仓链频]/)

mainland_terms = %w[默認 文件夾 用戶 網絡 軟件 視頻 鏈接 數據 運行 創建 鼠標 打印 質量圖]
mainland_terms.each do |term|
  errors << "Mainland China term remains: #{term}" if all_text.include?(term)
end

warehouse_exempted = all_text.gsub('管理倉庫揀貨與出貨', '')
errors << 'repository translated as 倉庫' if warehouse_exempted.include?('倉庫')

if errors.empty?
  puts "skills-tw validation passed (#{expected_targets.length} files)"
else
  warn errors.uniq.join("\n")
  exit 1
end
RUBY
