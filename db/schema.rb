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

ActiveRecord::Schema.define(version: 20171115093230) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string   "guid"
    t.integer  "user_id"
    t.integer  "character_id"
    t.string   "activity_type"
    t.integer  "activity_id"
    t.string   "activity_method"
    t.string   "activity_field"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["activity_type"], name: "index_activities_on_activity_type", using: :btree
    t.index ["character_id"], name: "index_activities_on_character_id", using: :btree
    t.index ["user_id"], name: "index_activities_on_user_id", using: :btree
  end

  create_table "advertisement_campaigns", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "caption"
    t.string   "link"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "amount_cents",       default: 0,     null: false
    t.string   "amount_currency",    default: "USD", null: false
    t.integer  "slots_filled",       default: 0
    t.string   "guid"
    t.string   "status"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean  "recurring",          default: false
    t.integer  "total_impressions",  default: 0
    t.integer  "total_clicks",       default: 0
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "slots_requested",    default: 0
    t.index ["guid"], name: "index_advertisement_campaigns_on_guid", using: :btree
    t.index ["user_id"], name: "index_advertisement_campaigns_on_user_id", using: :btree
  end

  create_table "advertisement_slots", force: :cascade do |t|
    t.integer  "active_campaign_id"
    t.integer  "reserved_campaign_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.datetime "last_impression_at"
    t.index ["active_campaign_id"], name: "index_advertisement_slots_on_active_campaign_id", using: :btree
    t.index ["reserved_campaign_id"], name: "index_advertisement_slots_on_reserved_campaign_id", using: :btree
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.integer  "visit_id"
    t.integer  "user_id"
    t.string   "name"
    t.jsonb    "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time", using: :btree
    t.index ["user_id", "name"], name: "index_ahoy_events_on_user_id_and_name", using: :btree
    t.index ["visit_id", "name"], name: "index_ahoy_events_on_visit_id_and_name", using: :btree
  end

  create_table "auctions", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "slot_id"
    t.integer  "starting_bid_cents",        default: 0,     null: false
    t.string   "starting_bid_currency",     default: "USD", null: false
    t.integer  "minimum_increase_cents",    default: 0,     null: false
    t.string   "minimum_increase_currency", default: "USD", null: false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "bids", force: :cascade do |t|
    t.integer  "auction_id"
    t.integer  "user_id"
    t.integer  "invitation_id"
    t.integer  "amount_cents",    default: 0,     null: false
    t.string   "amount_currency", default: "USD", null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "changelogs", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "changed_character_id"
    t.integer  "changed_user_id"
    t.integer  "changed_image_id"
    t.integer  "changed_swatch_id"
    t.text     "reason"
    t.json     "change_data"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "character_groups", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "slug"
    t.integer  "row_order"
    t.boolean  "hidden"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "characters_count",         default: 0, null: false
    t.integer  "visible_characters_count", default: 0, null: false
    t.integer  "hidden_characters_count",  default: 0, null: false
    t.index ["slug"], name: "index_character_groups_on_slug", using: :btree
    t.index ["user_id"], name: "index_character_groups_on_user_id", using: :btree
  end

  create_table "character_groups_characters", id: false, force: :cascade do |t|
    t.integer "character_group_id"
    t.integer "character_id"
    t.index ["character_group_id"], name: "index_character_groups_characters_on_character_group_id", using: :btree
    t.index ["character_id"], name: "index_character_groups_characters_on_character_id", using: :btree
  end

  create_table "characters", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "slug"
    t.string   "shortcode"
    t.text     "profile"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "gender"
    t.string   "species"
    t.string   "height"
    t.string   "weight"
    t.string   "body_type"
    t.string   "personality"
    t.text     "special_notes"
    t.integer  "featured_image_id"
    t.integer  "profile_image_id"
    t.text     "likes"
    t.text     "dislikes"
    t.integer  "color_scheme_id"
    t.boolean  "nsfw"
    t.boolean  "hidden"
    t.boolean  "secret"
    t.integer  "row_order"
    t.datetime "deleted_at"
  end

  create_table "color_schemes", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.text     "color_data"
    t.string   "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "feedback_replies", force: :cascade do |t|
    t.integer  "feedback_id"
    t.integer  "user_id"
    t.text     "comment"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["feedback_id"], name: "index_feedback_replies_on_feedback_id", using: :btree
    t.index ["user_id"], name: "index_feedback_replies_on_user_id", using: :btree
  end

  create_table "feedbacks", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "email"
    t.text     "comment"
    t.string   "trello_card_id"
    t.string   "source_url"
    t.integer  "visit_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.boolean  "done"
  end

  create_table "forum_karmas", force: :cascade do |t|
    t.integer  "karmic_id"
    t.integer  "karmic_type"
    t.integer  "user_id"
    t.boolean  "discord"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["karmic_id"], name: "index_forum_karmas_on_karmic_id", using: :btree
    t.index ["karmic_type"], name: "index_forum_karmas_on_karmic_type", using: :btree
  end

  create_table "forum_posts", force: :cascade do |t|
    t.integer  "thread_id"
    t.integer  "user_id"
    t.integer  "character_id"
    t.integer  "parent_post_id"
    t.string   "guid"
    t.text     "content"
    t.integer  "karma_total"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["character_id"], name: "index_forum_posts_on_character_id", using: :btree
    t.index ["guid"], name: "index_forum_posts_on_guid", using: :btree
    t.index ["parent_post_id"], name: "index_forum_posts_on_parent_post_id", using: :btree
    t.index ["thread_id"], name: "index_forum_posts_on_thread_id", using: :btree
    t.index ["user_id"], name: "index_forum_posts_on_user_id", using: :btree
  end

  create_table "forum_threads", force: :cascade do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.integer  "character_id"
    t.string   "topic"
    t.string   "slug"
    t.string   "shortcode"
    t.text     "content"
    t.boolean  "locked"
    t.integer  "karma_total"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["character_id"], name: "index_forum_threads_on_character_id", using: :btree
    t.index ["forum_id"], name: "index_forum_threads_on_forum_id", using: :btree
    t.index ["karma_total"], name: "index_forum_threads_on_karma_total", using: :btree
    t.index ["shortcode"], name: "index_forum_threads_on_shortcode", using: :btree
    t.index ["slug"], name: "index_forum_threads_on_slug", using: :btree
    t.index ["user_id"], name: "index_forum_threads_on_user_id", using: :btree
  end

  create_table "forums", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "slug"
    t.boolean  "locked"
    t.boolean  "nsfw"
    t.boolean  "no_rp"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["slug"], name: "index_forums_on_slug", using: :btree
  end

  create_table "images", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "artist_id"
    t.string   "caption"
    t.string   "source_url"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "row_order"
    t.string   "guid"
    t.string   "gravity"
    t.boolean  "nsfw"
    t.boolean  "hidden"
    t.integer  "gallery_id"
    t.datetime "deleted_at"
    t.string   "title"
    t.string   "background_color"
    t.integer  "comments_count"
    t.integer  "favorites_count"
    t.index ["guid"], name: "index_images_on_guid", using: :btree
  end

  create_table "invitations", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "email"
    t.datetime "seen_at"
    t.datetime "claimed_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "auth_code_digest"
  end

  create_table "items", force: :cascade do |t|
    t.integer  "seller_user_id"
    t.integer  "character_id"
    t.string   "type"
    t.string   "title"
    t.text     "description"
    t.integer  "amount_cents",       default: 0,     null: false
    t.string   "amount_currency",    default: "USD", null: false
    t.boolean  "requires_character"
    t.datetime "published_at"
    t.datetime "expires_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "sold"
    t.integer  "seller_id"
    t.index ["sold"], name: "index_items_on_sold", using: :btree
  end

  create_table "media_comments", force: :cascade do |t|
    t.integer  "media_id"
    t.integer  "user_id"
    t.integer  "reply_to_comment_id"
    t.text     "comment"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "guid"
    t.index ["guid"], name: "index_media_comments_on_guid", using: :btree
    t.index ["media_id"], name: "index_media_comments_on_media_id", using: :btree
    t.index ["reply_to_comment_id"], name: "index_media_comments_on_reply_to_comment_id", using: :btree
    t.index ["user_id"], name: "index_media_comments_on_user_id", using: :btree
  end

  create_table "media_favorites", force: :cascade do |t|
    t.integer  "media_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["media_id"], name: "index_media_favorites_on_media_id", using: :btree
    t.index ["user_id"], name: "index_media_favorites_on_user_id", using: :btree
  end

  create_table "order_items", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "item_id"
    t.integer  "slot_id"
    t.integer  "auction_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "amount_cents"
    t.string   "amount_currency",       default: "USD"
    t.integer  "processor_fee_cents"
    t.integer  "marketplace_fee_cents"
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "email"
  end

  create_table "organization_memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.boolean  "admin"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["admin"], name: "index_organization_memberships_on_admin", using: :btree
    t.index ["organization_id"], name: "index_organization_memberships_on_organization_id", using: :btree
    t.index ["user_id"], name: "index_organization_memberships_on_user_id", using: :btree
  end

  create_table "patreon_patrons", force: :cascade do |t|
    t.string   "patreon_id"
    t.string   "email"
    t.string   "full_name"
    t.string   "image_url"
    t.boolean  "is_deleted"
    t.boolean  "is_nuked"
    t.boolean  "is_suspended"
    t.string   "status"
    t.string   "thumb_url"
    t.string   "twitch"
    t.string   "twitter"
    t.string   "youtube"
    t.string   "vanity"
    t.string   "url"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "patreon_pledges", force: :cascade do |t|
    t.string   "patreon_id"
    t.integer  "amount_cents"
    t.datetime "declined_since"
    t.boolean  "patron_pays_fees"
    t.integer  "pledge_cap_cents"
    t.integer  "patreon_reward_id"
    t.integer  "patreon_patron_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "patreon_rewards", force: :cascade do |t|
    t.string   "patreon_id"
    t.integer  "amount_cents"
    t.text     "description"
    t.string   "image_url"
    t.boolean  "requires_shipping"
    t.string   "title"
    t.string   "url"
    t.boolean  "grants_badge"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "payment_transfers", force: :cascade do |t|
    t.integer  "seller_id"
    t.integer  "payment_id"
    t.integer  "order_id"
    t.string   "processor_id"
    t.string   "type"
    t.integer  "amount_cents",    default: 0,     null: false
    t.string   "amount_currency", default: "USD", null: false
    t.string   "status"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["order_id"], name: "index_payment_transfers_on_order_id", using: :btree
    t.index ["payment_id"], name: "index_payment_transfers_on_payment_id", using: :btree
    t.index ["seller_id"], name: "index_payment_transfers_on_seller_id", using: :btree
    t.index ["type"], name: "index_payment_transfers_on_type", using: :btree
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "processor_id"
    t.integer  "amount_cents",        default: 0,     null: false
    t.string   "amount_currency",     default: "USD", null: false
    t.string   "state"
    t.string   "failure_reason"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "type"
    t.integer  "processor_fee_cents"
    t.index ["type"], name: "index_payments_on_type", using: :btree
  end

  create_table "permissions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
  end

  create_table "sellers", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "type"
    t.integer  "address_id"
    t.string   "processor_id"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "dob"
    t.datetime "tos_acceptance_date"
    t.string   "tos_acceptance_ip"
    t.string   "default_currency"
    t.string   "processor_type"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["type"], name: "index_sellers_on_type", using: :btree
    t.index ["user_id"], name: "index_sellers_on_user_id", using: :btree
  end

  create_table "slots", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "extends_slot_id"
    t.string   "title"
    t.text     "description"
    t.string   "color"
    t.integer  "amount_cents",       default: 0,     null: false
    t.string   "amount_currency",    default: "USD", null: false
    t.boolean  "requires_character"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "swatches", force: :cascade do |t|
    t.integer  "character_id"
    t.string   "name"
    t.string   "color"
    t.text     "notes"
    t.integer  "row_order"
    t.string   "guid"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "transaction_resources", force: :cascade do |t|
    t.integer  "transaction_id"
    t.string   "processor_id"
    t.string   "type"
    t.integer  "amount_cents",             default: 0,     null: false
    t.string   "amount_currency",          default: "USD", null: false
    t.integer  "transaction_fee_cents",    default: 0,     null: false
    t.string   "transaction_fee_currency", default: "USD", null: false
    t.string   "payment_mode"
    t.string   "status"
    t.string   "reason_code"
    t.datetime "valid_until"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "payment_id"
    t.string   "processor_id"
    t.integer  "amount_cents",    default: 0,     null: false
    t.string   "amount_currency", default: "USD", null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "transfers", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "item_id"
    t.integer  "sender_user_id"
    t.integer  "destination_user_id"
    t.integer  "invitation_id"
    t.datetime "seen_at"
    t.datetime "claimed_at"
    t.datetime "rejected_at"
    t.string   "status"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "guid"
    t.index ["guid"], name: "index_transfers_on_guid", using: :btree
  end

  create_table "user_followers", force: :cascade do |t|
    t.integer  "following_id"
    t.integer  "follower_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["follower_id"], name: "index_user_followers_on_follower_id", using: :btree
    t.index ["following_id"], name: "index_user_followers_on_following_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.text     "profile"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.json     "settings"
    t.string   "type"
    t.string   "auth_code_digest"
    t.integer  "parent_user_id"
    t.string   "unconfirmed_email"
    t.datetime "email_confirmed_at"
    t.index ["parent_user_id"], name: "index_users_on_parent_user_id", using: :btree
    t.index ["type"], name: "index_users_on_type", using: :btree
  end

  create_table "visits", force: :cascade do |t|
    t.string   "visit_token"
    t.string   "visitor_token"
    t.string   "ip"
    t.text     "user_agent"
    t.text     "referrer"
    t.text     "landing_page"
    t.integer  "user_id"
    t.string   "referring_domain"
    t.string   "search_keyword"
    t.string   "browser"
    t.string   "os"
    t.string   "device_type"
    t.integer  "screen_height"
    t.integer  "screen_width"
    t.string   "country"
    t.string   "region"
    t.string   "city"
    t.string   "postal_code"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_term"
    t.string   "utm_content"
    t.string   "utm_campaign"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_visits_on_user_id", using: :btree
    t.index ["visit_token"], name: "index_visits_on_visit_token", unique: true, using: :btree
  end

end
