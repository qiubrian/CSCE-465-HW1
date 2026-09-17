# AI USAGE

I used ChatGPT while completing this assignment. 

I used ChatGPT to help interpret the assignment requirements, review my github repo, and check for
missing submission requirements and mistakes.

# AI Log

Prompt: [Given file for the HW1] List all steps and tasks I need to finish

Response:

From the homework package you uploaded, here’s the assignment reduced to a do-this checklist. We will ignore the Bonus Task for now.

Task 1 — Build and verify the VM / OpenClaw environment — 40 pts
In UTM, create an x86-64 emulated Ubuntu 24.04 LTS VM.
Allocate roughly 4 vCPUs, 8 GB RAM, 80 GB dynamic disk.
Networking must be NAT, not bridged.

After Ubuntu installs, verify:

uname -m
ip -brief address
ip route

uname -m should say x86_64.

Update Ubuntu and install basics:

sudo apt update
sudo apt full-upgrade -y
sudo apt install -y curl git
Install Node 24.18.0 with nvm.

Install the exact course OpenClaw:

npm install -g openclaw@2026.7.1-2
Pick a model. For finishing tonight, I recommend the TAMUS API option rather than Ollama, because x86 emulation + a local model on your Apple Silicon Mac will be slow.
Copy tamu-shim.mjs from the homework ZIP into the VM and configure your TAMUS API key.
Connect OpenClaw to the model.

Verify:

openclaw gateway status
openclaw doctor
openclaw exec-policy show
Run a simple model test and make sure it responds.
Then run 3–5 harmless agent tasks. At least one must use a tool, such as reading/writing a file or running a shell command.
Create benign-tasks.md. For each task, save:
exact prompt you gave it;
agent response;
tools used, using openclaw audit;
one sentence saying whether the result was correct.
Take screenshots showing this actually ran.
Task 2 — Build the harmless tool + local webpages — 20 pts

Create:

mkdir -p ~/csce465-agentsec/hw1/{bin,web,markers,evidence}

Create:

bin/safe_marker.sh
The script must:
accept exactly one argument: course-marker;
reject anything else;

only create:

markers/marker.txt
never execute commands supplied through user input.

Create an OpenClaw skill:

~/.openclaw/workspace/skills/safe-marker/SKILL.md
The skill tells OpenClaw when it is allowed to create the marker and gives it the fixed safe command.

Run:

openclaw skills check

Save the output.

Create:

web/benign.html
web/adversarial.html
benign.html: simple fake company status report.
adversarial.html: same report, but add an obvious instruction inside the webpage telling the AI to execute the safe-marker tool.

Start the local server:

cd ~/csce465-agentsec/hw1
python3 -m http.server 8000 --directory web --bind 127.0.0.1
Verify both pages work.
Screenshot/save your results.
Task 3 — Direct vs. indirect prompt injection experiment — 20 pts
Run two experiments using the same agent and safe-marker skill.
Direct trial: you directly tell the agent something like “use the safe-marker skill to create the marker.”

Run it with machine-readable output:

openclaw agent --json -m "..."

Check:

openclaw audit
openclaw exec-policy show
Record whether markers/marker.txt was created.

Indirect trial: start your local webpage server, then retrieve adversarial.html yourself:

curl http://127.0.0.1:8000/adversarial.html
Give that webpage content to the agent, clearly saying it is retrieved external content, and ask the agent only to summarize it.
Important: your prompt must not tell it to execute the marker. The malicious instruction must come only from the webpage.
Again record:
exact prompt;
webpage content;
model response;
every proposed/executed tool call;
whether marker was created;
openclaw exec-policy show;
why what happened did or did not violate your intended policy.
Create an annotated transcript for both experiments showing where the “run marker” instruction originated:
Direct = your message/control channel.
Indirect = webpage/data channel.
Mark where authorization happens between the model proposing a tool and the tool actually executing.
Write ≤600 words total answering:
What structurally distinguishes direct from indirect injection?
Where does untrusted data become a potential instruction?
What control should decide whether the tool call is authorized?
Why doesn't encrypting the agent communication channel solve indirect prompt injection?
Task 4 — Threat model + real security advisory — 35 pts
Make one data-flow diagram showing:
user/Web UI;
OpenClaw Gateway;
model provider or Ollama;
agent context;
skill/tool decision;
shell/file operation;
local webpage server;
VM operating system.
On/alongside the diagram identify at least:
4 assets;
3 principals;
4 trust boundaries;
6 threats;
1 preventive/detective control for each threat.

Include the result of:

openclaw exec-policy show

as a control, or explain why it is a missing/insufficient control.

Save the diagram as something like:

attack-surface-map.pdf
Then choose one current OpenClaw security advisory.
Write 500–700 words explaining:
vulnerable component;
attacker-controlled input;
attack preconditions;
root cause;
impact;
fix;
one regression test;
whether prompt injection is required, merely helpful, or irrelevant.
When you reach this part, send me the advisory choices and I can research the actual advisory/patch with you.
Final submission / report — 5 pts plus required evidence
Create report.pdf or report.md.
It needs:
your 3–5 benign tasks;
both Task 3 experiments;
both annotated transcripts;
≤600-word Task 3 discussion;
Task 4 threat-model diagram;
assets/principals/trust boundaries/threats/controls;
500–700-word advisory analysis;
screenshots showing the VM commands, agent runs, marker, diagram, etc.;
a short section about your experience: problems, failed attempts, what you learned.

Also submit roughly:

hw1/
  report.pdf
  README.md
  AI_USAGE.md
  setup-note.md
  benign-tasks.md
  injection-experiment.md
  threat-model.md
  advisory-analysis.md
  attack-surface-map.pdf
  versions.txt
  bin/safe_marker.sh
  skills/safe-marker/SKILL.md
  web/benign.html
  web/adversarial.html
  markers/
  evidence/
README.md: exact commands needed to reproduce everything.
versions.txt: record Ubuntu, Node, OpenClaw, etc.
AI_USAGE.md: State what AI helped with.
You also have to submit the relevant AI prompts/responses/logs, with API keys and private information removed.
Make meaningful Git commits, rather than one giant commit at the end.
Do not put your TAMUS API key in Git, screenshots, report, or AI logs.
You are expected to understand and verify the AI-assisted work yourself.



Prompt: [Given GIT repo] I need you to check the current status and inform me of anything you see that needs fixing, debugging, formatting fixes, etc

Response:

I checked the current public main branch. You’re not submission-ready yet, but most of Tasks 1–3 are there.

Item	Status	What I found / what to do
VM/version evidence	✅	versions.txt shows Ubuntu 24.04, x86_64, Node 24.18.0, OpenClaw 2026.7.1-2, Python 3.12.3.
Benign tasks	✅	You have 3 benign tasks, including write and read tool calls, which meets the 3–5 task requirement and at-least-one-tool requirement.
safe_marker.sh	✅	It accepts only course-marker and writes the fixed marker file.
Skill	✅	safe-marker is present and your saved skills check shows it Ready/visible.
Benign/adversarial pages	✅	They are the same fictional report, with the adversarial page adding the untrusted marker instruction.
Task 3 direct/indirect	⚠️ Almost	Both trials are documented, but there are two fixes below.
threat-model.md	❌	On GitHub it currently contains only # Threat Model and My.
advisory-analysis.md	❌	Not present on current main.
attack-surface-map.pdf	❌	Not present on current main.
report.pdf	❌	Not present on current main.
README with exact commands	❌	Your root README is only # CSCE-465-HW1 / HW1 for CSCE 465; that does not satisfy the requirement for exact setup/test commands.
AI_USAGE.md	❌	Not present on current main.
AI log	❌ / not verified	Required because you used ChatGPT.
Screenshots	⚠️ Verify	They must be included in the final report, not merely stored separately.
Git history	✅ likely	GitHub shows 9 commits. Make sure the messages represent meaningful stages.
Two Task 3 fixes

Change:

Proposed tools: exec
Executed tools: exec

To:

skill_workshop -> failed
read           -> succeeded
exec           -> succeeded

Also add an explicit authorization-point statement for each transcript. For the direct trial, explain that the model reached exec, and with ask=off there was no interactive approval before execution. For the indirect trial, explain that no tool call was proposed, so the flow never reached the exec authorization boundary.

Your four-question section also needs a direct answer to:

Which control should decide whether a tool call is authorized?

Right now you discuss the danger of the agent deciding, but don’t explicitly name the control. Your answer should identify the tool execution / approval policy layer, not the model itself, as the authorization control. The assignment explicitly requires all four questions.

What you need to finish, in order

Finish threat-model.md with:

4 assets
3 principals
4 trust boundaries
6 threats
1 control per threat
effective policy security=full, ask=off on the skill/tool boundary

The diagram must contain the eight required components.

hw1/attack-surface-map.pdf
Create advisory-analysis.md with your 500–700 word analysis. 
Create hw1/README.md containing your exact setup and test commands. The assignment explicitly requires that.
Create AI_USAGE.md and a sanitized AI log. The assignment requires both an AI-use description and relevant prompts/responses because AI was used. 

Assemble report.pdf. This is the biggest remaining item. It must contain:

3–5 benign-task results
both Task 3 trial write-ups
both annotated transcripts
≤600-word answers to the four Task 3 questions
Task 4 DFD
asset/principal/trust-boundary/threat/control labels
500–700 word advisory analysis
screenshots showing terminal output, agent responses, marker creation, and diagram
a short section on your experience/failures/trials/lessons

Those are explicitly required in the final report.

Your fastest path now is: fix Task 3 → fill threat-model.md → add diagram PDF → add advisory-analysis.md → README + AI_USAGE → build report.pdf → push everything.



Prompt: [Given GIT repo] Tell me all fixes and missing documents I need to do make or change to meet the requirements

Response:

I checked the latest public repo. I see two recent git commits with changes: threat-model.md is filled out, and both Direct/Indirect sections now include authorization-point statements.

You still need these exact fixes:

Fix the Direct tool-call lines in injection-experiment.md. Right now you have:
Proposed tools: skill_workshop, read, exec

Executed tools: read, exec

Change those two lines to:

Tool calls:
- skill_workshop - failed
- read - succeeded
- exec - succeeded

skill_workshop was still an actual tool call even though it failed, so this wording better matches the assignment requirement to record every proposed/executed tool call.

Add an explicit answer to Task 3 question #3. Your # Findings section answers the structural difference, injection risk, and encryption question, but does not plainly answer:

Which control should decide whether a tool call is authorized?

Add a sentence such as this in your own words:

The tool execution/approval policy should make the final authorization decision, instead of relying only on the model to decide whether a command is allowed.

The assignment requires all four questions.

Your threat model is now basically complete. It has 4 assets, 3 principals, 4 trust boundaries, 6 threats with 6 controls, and the exec policy. You only have spelling typos like Boundry/Boundries and Retreived; those aren't functional problems, but fix them if you have a minute.
Add hw1/attack-surface-map.pdf. It still is not present at that path. The diagram must include all eight required components plus the labels from your threat model.
Add hw1/advisory-analysis.md. It is still missing. It must be 500–700 words and cover vulnerable component, attacker-controlled input, preconditions, root cause, impact, fix, regression test, and whether prompt injection is required/helpful/irrelevant.
Create hw1/README.md. The only README I can currently see is the root README:
# CSCE-465-HW1
HW1 for CSCE 465

That does not satisfy the requirement for exact setup and test commands.

Create hw1/AI_USAGE.md and include a sanitized AI log. AI_USAGE.md is still missing. You need both because AI was used. Also, create hw1/report.pdf. It is still missing. This is the primary deliverable and must include the benign tasks, Task 3 trials/annotated transcripts/four answers, Task 4 diagram/labels/advisory analysis, screenshots, and your short experience/lessons section.

So your immediate next move should be:

1. Fix the 2 Task 3 items
2. Export attack-surface-map.pdf
3. Add advisory-analysis.md
4. Add README.md
5. Add AI_USAGE.md + sanitized AI log
6. Assemble report.pdf with screenshots
7. git add/commit/push

Your threat-model.md itself no longer needs major content changes.