# Productivity

一般性的工作流程工具，並非針對程式碼設計。

## 使用者觸發

只有在你輸入指令時才會啟動（Claude Code：`disable-model-invocation: true`；Codex：`agents/openai.yaml` 中的 `policy.allow_implicit_invocation: false`）。

- **[grill-me](./grill-me/SKILL.md)**：針對某個計畫或設計進行不留情面的連番提問，直到設計樹的每一個分支都被釐清為止。
- **[handoff](./handoff/SKILL.md)**：將目前的對話濃縮成一份交接文件，讓另一個代理人可以接續進行這項工作。
- **[teach](./teach/SKILL.md)**：以目前的目錄作為具有狀態的教學工作空間，透過多次的作業階段教導使用者新的技能或概念。
- **[to-questionnaire](./to-questionnaire/SKILL.md)**：把一個你無法獨自回答的決策，轉換成一份 Markdown 問卷，交給唯一能回答的人（可以非同步填寫，也可以在會議中一起完成）。
- **[wait-what](./wait-what/SKILL.md)**：一旦某則訊息讓你聽不懂，就立刻啟用這個技能。代理人會用你在 `CONTEXT.md` 中的詞彙，補上你所欠缺的脈絡，並以淺顯易懂的方式重新表達一次。

## 模型觸發

模型或使用者皆可觸發（具備豐富的觸發語句，讓模型能夠主動使用）。

- **[grilling](./grilling/SKILL.md)**：針對某個計畫、決策或想法對使用者進行不留情面的連番提問，直到設計樹的每一個分支都被釐清為止。
- **[writing-for-agents](./writing-for-agents/SKILL.md)**：為代理人撰寫文件：技能（skills）、AGENTS.md/CLAUDE.md，以及任何代理人透過指標存取的文件。
