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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110122200505) do

  create_table "access_code_requests", :force => true do |t|
    t.string   "email"
    t.datetime "code_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "access_code_requests", ["email"], :name => "index_access_code_requests_on_email"

  create_table "access_codes", :force => true do |t|
    t.string   "code"
    t.integer  "uses",       :default => 0,     :null => false
    t.boolean  "unlimited",  :default => false, :null => false
    t.datetime "expires_at"
    t.integer  "use_limit",  :default => 1,     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "access_codes", ["code"], :name => "index_access_codes_on_code"

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.string   "content"
    t.boolean  "correct"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"

  create_table "app_feeds", :force => true do |t|
    t.string   "title"
    t.string   "url",               :limit => 2083
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort",                              :default => 0
    t.integer  "project_id"
  end

  create_table "app_links", :force => true do |t|
    t.string   "title"
    t.string   "url",               :limit => 2083
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort",                              :default => 0
    t.integer  "project_id"
  end

  create_table "app_maps", :force => true do |t|
    t.string   "title"
    t.string   "google_map_feed",   :limit => 2083
    t.string   "string",            :limit => 2083
    t.string   "location"
    t.integer  "zoom_level"
    t.decimal  "lat",                               :precision => 15, :scale => 10
    t.decimal  "lng",                               :precision => 15, :scale => 10
    t.text     "icon_list"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort",                                                              :default => 0
    t.integer  "project_id"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
  end

  create_table "facts", :force => true do |t|
    t.text     "content"
    t.string   "location"
    t.decimal  "lat",                              :precision => 15, :scale => 10
    t.decimal  "lng",                              :precision => 15, :scale => 10
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.string   "aasm_state"
    t.integer  "photo_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "subtitle",                                                         :default => ""
    t.integer  "factable_id",                                                      :default => 0
    t.string   "factable_type",      :limit => 15,                                 :default => ""
    t.integer  "vertical_offset"
    t.integer  "horizontal_offset"
    t.integer  "position",                                                         :default => 0
  end

  add_index "facts", ["lat", "lng"], :name => "index_facts_on_lat_and_lng"

  create_table "project_layouts", :force => true do |t|
    t.string   "name"
    t.integer  "sort"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "view"
  end

  create_table "project_roles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_roles", ["user_id", "project_id"], :name => "index_project_roles_on_user_id_and_project_id"

  create_table "project_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.integer  "project_type_id"
    t.string   "name"
    t.text     "description"
    t.datetime "deadline"
    t.string   "aasm_state"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.integer  "comment_count",                 :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "app_items"
    t.integer  "project_layout_id"
    t.string   "app_icon_file_name"
    t.string   "app_icon_content_type"
    t.string   "app_icon_file_size"
    t.string   "splash_image_file_name"
    t.string   "splash_image_content_type"
    t.string   "splash_image_file_size"
    t.string   "background_image_file_name"
    t.string   "background_image_content_type"
    t.string   "background_image_file_size"
  end

  create_table "questions", :force => true do |t|
    t.integer  "fact_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["fact_id"], :name => "index_questions_on_fact_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
    t.string "icon"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "access_code_id"
    t.string   "name"
    t.string   "cached_slug"
    t.datetime "deleted_at"
    t.string   "username"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
