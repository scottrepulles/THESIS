🎮 SQL DEFENDER (GameMaker)
📌 Project Overview

Tower Defense v1 is a GameMaker Studio 2 project developed as part of an academic thesis.
The project implements a full tower defense game with structured assets, scripts, rooms, and automated validation using GitHub Actions (CI/CD).

This repository emphasizes:

Proper GameMaker project structure

Strict resource integrity

Automated validation (unit tests)

Reproducibility and maintainability

🧱 Project Structure
Tower Defense v1(back up6)/
├── fonts/
├── notes/
│   └── Documentation/
├── objects/
├── options/
├── paths/
├── rooms/
├── scripts/
├── sequences/
├── shaders/
├── sounds/
├── sprites/
├── Tower Defense v1(main).yyp
└── README.md


Each folder corresponds to a GameMaker resource type and is validated automatically by CI.

📄 GameMaker Project File (.yyp)

File: Tower Defense v1(main).yyp

Format: Strict JSON

Engine: GameMaker Studio 2

Project Type: GMProject

Template Type: game

⚠️ Important Rule

Comments are NOT allowed inside .yyp files.

Because .yyp uses strict JSON:

// comments ❌

/* */ comments ❌

All documentation must be placed in:

README.md

GameMaker Notes

CI workflow comments

⚙️ Critical Configuration Rules
isEcma
"isEcma": false


Enforced by CI

Changing this to true will fail the build

Required for project compatibility and grading consistency

🧪 Automated Validation (CI / Unit Tests)

This project uses GitHub Actions to run 24 unit tests on every push and pull request to the cicd branch.

What the tests validate:
🔹 Project Integrity

.yyp file exists and is readable

Project type is GMProject

Required root keys exist:

resources

Folders

RoomOrderNodes

TextureGroups

templateType is game

🔹 Configuration Validation

isEcma exists

isEcma === false (real assertion, not string matching)

🔹 Directory Structure

Ensures these folders exist:

fonts

notes

objects

paths

rooms

scripts

sequences

shaders

sounds

sprites

🔹 Resource Integrity

Every resource listed in .yyp exists on disk

No duplicate resource paths

At least one resource is declared

🔹 Rooms & Order

All RoomOrderNodes reference valid room files

At least one room exists

Room order integrity is preserved

🧠 Notes & Documentation

All internal explanations are stored using GameMaker Notes:

notes/Documentation/Documentation.yy


These notes include:

Design explanations

Gameplay logic notes

Development decisions

CI/CD expectations

This is the recommended way to document GameMaker projects.

🔁 CI/CD Workflow

Location: .github/workflows/test.yml

Triggered on:

push to cicd

pull_request to cicd

Runs on: ubuntu-latest

Why CI is used

Prevents broken resources

Ensures project consistency

Demonstrates professional software engineering practice

Required for thesis evaluation

🎓 Academic Context

This repository demonstrates:

Real-world project validation

Automated testing without engine execution

Static analysis of GameMaker projects

Proper handling of JSON-based engine files

The project avoids modifying engine internals and instead validates structure and integrity externally using CI.

🚫 What NOT to Do

❌ Do not add comments inside .yyp

❌ Do not rename resource paths without updating .yyp

❌ Do not delete required folders

❌ Do not change isEcma to true

All of the above will cause CI failure.

✅ Summary

✔ GameMaker-compliant

✔ CI-validated

✔ Thesis-ready

✔ Strict JSON handling

✔ Professional project structure
