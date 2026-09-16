# Threat Model

Assets: 

Asset 1: TAMUS API credentials
Asset 2: Files inside the VM
Asset 3: Shell's ability to exec
Asset 4: Openclaw config and skills

Principals:

Principal 1: User
Principal 2: Openclaw agent or model
Principal 3: External content/sources

Trust Boundries: 

Trust Boundry 1: User to Openclaw agent/model
Trust Boundry 2: Retreived resources/webpage to agent context
Trust Boundry 3: Skill/tool decision to exec
Trust Boundry 4: Openclaw tools to VM OS

Threats and Controls:

Threat 1: Indirect prompt injection
Control 1: Treat retreived resources/webpages as untrusted instead of user authorization
Threat 2: Unauthorized command execution
Control 2: Require approval to execute commands
Threat 3: Overallowance on exec policy
Control 3: Restrict exec policy
Threat 4: Malicious or modified skills
Control 4: Review skills and keep commands fixed
Threat 5: Credential exposure
Control 5: Keep credentials secret and away from public areas like Git
Threat 6: Unauthorized file modification
Control 6: Restrict file writing tool permissions

Exec Policy:

Effective policy:
- security = full
- ask = off
- askFallback = deny
The exec policy applies at trust boundry 3, between skill decision and execution. Since ask is off, there is no interactive approval before an exec request runs.