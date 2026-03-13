# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_13_104007) do
  create_table "buzzes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "player_id", null: false
    t.integer "team_id", null: false
    t.integer "turn_id", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_buzzes_on_player_id"
    t.index ["team_id"], name: "index_buzzes_on_team_id"
    t.index ["turn_id"], name: "index_buzzes_on_turn_id"
  end

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "host_token", null: false
    t.json "settings", default: {}
    t.string "status", default: "lobby", null: false
    t.datetime "updated_at", null: false
    t.index ["host_token"], name: "index_games_on_host_token", unique: true
  end

  create_table "players", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_host", default: false, null: false
    t.string "name", null: false
    t.boolean "online", default: true, null: false
    t.integer "team_id", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "questions", force: :cascade do |t|
    t.json "aliases"
    t.string "correct_answer"
    t.datetime "created_at", null: false
    t.string "difficulty"
    t.json "options"
    t.text "prompt"
    t.string "qtype"
    t.string "region"
    t.string "source"
    t.string "topic"
    t.datetime "updated_at", null: false
  end

  create_table "rounds", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "game_id", null: false
    t.integer "number", null: false
    t.integer "question_index", default: 0, null: false
    t.json "rep_question_counts", default: {}, null: false
    t.json "reps", default: {}
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_rounds_on_game_id"
  end

  create_table "teams", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "game_id", null: false
    t.boolean "lifeline_single_used", default: false, null: false
    t.boolean "lifeline_team_used", default: false, null: false
    t.string "name", null: false
    t.integer "score", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_teams_on_game_id"
  end

  create_table "turns", force: :cascade do |t|
    t.boolean "answered_correct"
    t.string "chaos_effect"
    t.string "chaos_outcome"
    t.integer "chaos_roll"
    t.datetime "created_at", null: false
    t.string "difficulty"
    t.string "lifeline_type"
    t.boolean "multiplier", default: false, null: false
    t.integer "points_awarded"
    t.integer "question_id"
    t.json "question_payload"
    t.string "question_source"
    t.integer "rep_id"
    t.boolean "reroll_difficulty_used", default: false, null: false
    t.boolean "reroll_topic_used", default: false, null: false
    t.integer "round_id", null: false
    t.boolean "steal_correct"
    t.boolean "steal_open", default: false, null: false
    t.datetime "steal_started_at"
    t.integer "steal_team_id"
    t.integer "steal_winner_player_id"
    t.integer "steal_winner_team_id"
    t.string "swap_difficulty"
    t.integer "swap_roll"
    t.integer "swap_target_team_id"
    t.integer "team_id", null: false
    t.integer "timer_seconds"
    t.datetime "timer_started_at"
    t.string "topic"
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_turns_on_question_id"
    t.index ["rep_id"], name: "index_turns_on_rep_id"
    t.index ["round_id"], name: "index_turns_on_round_id"
    t.index ["steal_open"], name: "index_turns_on_steal_open"
    t.index ["steal_team_id"], name: "index_turns_on_steal_team_id"
    t.index ["steal_winner_player_id"], name: "index_turns_on_steal_winner_player_id"
    t.index ["steal_winner_team_id"], name: "index_turns_on_steal_winner_team_id"
    t.index ["swap_target_team_id"], name: "index_turns_on_swap_target_team_id"
    t.index ["team_id"], name: "index_turns_on_team_id"
  end

  add_foreign_key "buzzes", "players"
  add_foreign_key "buzzes", "teams"
  add_foreign_key "buzzes", "turns"
  add_foreign_key "players", "teams"
  add_foreign_key "rounds", "games"
  add_foreign_key "teams", "games"
  add_foreign_key "turns", "rounds"
  add_foreign_key "turns", "teams"
end
