# Project Summary

## Goal

Build a host-led "Roll The Dice" web app with realtime gameplay flow, manual dice input, question assignment, scoring, steal/buzz mechanics, and polished UI. Add a public rules page, host-only leaderboard, and improve usability. Prevent a single player session from joining multiple games. Add Fly.io deployment configuration.

## Key Instructions

- Rails 8 with Hotwire/Turbo Streams and host-led flow
- Manual dice input: host enters topic/difficulty (no auto-roll)
- Block question assignment unless topic and difficulty are set
- Rerolls are optional markers only (no enforcement)
- Steal: only non-answering teams see banner; banner disappears when winner chosen; winner shown on host + player
- Questions per rep are dynamic per game (host set); progress is per rep per round
- Avoid full page reloads; use Turbo Streams
- Tailwind for UI; keep "Back to Host" fixed top-right
- Workflow: multiple PRs with story commits; avoid amend unless asked
- Rules page is public and print-friendly; supports dynamic questions per rep via `?game_id=`
- Host-only live leaderboard with short route

## Current State

### Gameplay and UI

- Manual dice entry in host UI; question assignment blocked until both values set
- `QuestionPicker` prioritizes SA pack then OTDB
- `ScoreCalculator` handles 2/4/5 points, multiplier, chaos double/penalty
- Steal flow supports open/close, award, and winner display on host
- Correct -> ready_for_next; Next Question resets same turn and scrolls to Dice Results
- Next Action banner for host; state-based panel visibility
- Tailwind applied across host/player/landing

### Realtime

- Turbo Streams broadcasts from `GameBroadcaster`
- Action responses avoid full reloads
- `host_scroll_controller.js` preserves host scroll
- `focus_on_connect_controller.js` scrolls to Dice Results

### Rules and Leaderboard

- Public `/rules` page with flow, lifelines, chaos, and examples
- Rules link on landing, host, and join
- Host-only live leaderboard with short route `leaderboard/:id/:token`

### Session Locking

- Player session locked to one game using `session[:player_game_id]`
- Join page shows lock prompt and "Leave current game" action

### Deployment

- `fly.toml` added for Fly.io
- App name `trustthedice`, region `jnb`, sqlite at `/data/production.sqlite3`
- `internal_port = 8080`, mount `/data`, `vm.memory_mb = 256`

## Open Items (Needs Verification)

- PRs 17-22 may still be open:
  - Steal banner for non-answering teams + buzz endpoint + winner on player
  - Player shows latest points after question
  - Host leaderboard (short route + live updates)
  - Back to Host fixed link (session stored on host page)
  - Lock player session to a single game
  - Join-lock notice showing current game id
- `fly.toml` was committed directly to main

## Key Files

### Gameplay and Flow

- `app/controllers/turns_controller.rb`
- `app/views/games/_host_state.html.erb`
- `app/views/games/_player_state.html.erb`
- `app/services/game_broadcaster.rb`
- `app/services/question_picker.rb`
- `app/services/open_trivia_client.rb`
- `app/services/score_calculator.rb`
- `app/models/turn.rb`
- `app/models/round.rb`
- `app/models/game.rb`

### Session Locking

- `app/controllers/players_controller.rb`
- `app/controllers/games_controller.rb`
- `app/controllers/application_controller.rb`
- `app/views/games/join.html.erb`
- `config/routes.rb`

### UI and Tailwind

- `app/views/layouts/application.html.erb`
- `app/assets/tailwind/application.css`
- `app/views/games/show.html.erb`
- `app/views/games/new.html.erb`
- `app/views/games/join.html.erb`
- `app/javascript/controllers/focus_on_connect_controller.js`
- `app/javascript/controllers/host_scroll_controller.js`
- `app/javascript/controllers/disable_on_submit_controller.js`

### Rules and Leaderboard

- `app/controllers/rules_controller.rb`
- `app/views/rules/show.html.erb`
- `app/controllers/leaderboards_controller.rb`
- `app/views/leaderboards/show.html.erb`
- `app/views/leaderboards/_leaderboard_state.html.erb`
- `config/routes.rb`

### Seeds and Migrations

- `db/seeds.rb`
- `db/seed_data/sa_questions.json`
- `db/migrate/20260313100128_add_turn_question_flow_fields.rb`
- `db/migrate/20260313104007_add_rep_question_counts_to_rounds.rb`
- `db/migrate/20260313105509_add_state_to_turns.rb`
