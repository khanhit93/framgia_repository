# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160809044542) do

  create_table "activities", force: :cascade do |t|
    t.integer  "action_type"
    t.integer  "target_id"
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "activities", ["user_id", "created_at"], name: "index_activities_on_user_id_and_created_at"
  add_index "activities", ["user_id"], name: "index_activities_on_user_id"

  create_table "categories", force: :cascade do |t|
    t.string   "conten"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lessons", force: :cascade do |t|
    t.boolean  "is_complete"
    t.integer  "user_id"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "lessons", ["category_id", "created_at"], name: "index_lessons_on_category_id_and_created_at"
  add_index "lessons", ["category_id"], name: "index_lessons_on_category_id"
  add_index "lessons", ["user_id", "created_at"], name: "index_lessons_on_user_id_and_created_at"
  add_index "lessons", ["user_id"], name: "index_lessons_on_user_id"

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id"

  create_table "results", force: :cascade do |t|
    t.boolean  "is_correct",     default: false
    t.integer  "word_id"
    t.integer  "word_answer_id"
    t.integer  "lesson_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "results", ["lesson_id"], name: "index_results_on_lesson_id"
  add_index "results", ["word_answer_id"], name: "index_results_on_word_answer_id"
  add_index "results", ["word_id"], name: "index_results_on_word_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "telephone"
    t.string   "password_digest"
    t.boolean  "sex"
    t.boolean  "is_admin",          default: false
    t.boolean  "activation"
    t.datetime "active_at"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "activation_digest"
    t.string   "remember_digest"
  end

  create_table "word_answers", force: :cascade do |t|
    t.string   "content"
    t.boolean  "correct_answer"
    t.integer  "word_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "word_answers", ["word_id"], name: "index_word_answers_on_word_id"

  create_table "words", force: :cascade do |t|
    t.string   "content"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "words", ["category_id", "created_at"], name: "index_words_on_category_id_and_created_at"
  add_index "words", ["category_id"], name: "index_words_on_category_id"

end
