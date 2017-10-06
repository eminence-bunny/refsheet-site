require_dependency Rails.root.join 'app/serializers/activity/image_serializer'
require_dependency Rails.root.join 'app/serializers/activity/character_serializer'
require_dependency Rails.root.join 'app/serializers/activity/discussion_serializer'
require_dependency Rails.root.join 'app/serializers/activity/comment_serializer'

class ActivitySerializer < ActiveModel::Serializer
  attributes :id,
             :user,
             :character,
             :activity_type,
             :activity_method,
             :activity_field,
             :activity,
             :timestamp

  has_one :user, serializer: UserIndexSerializer
  has_one :character, serializer: ImageCharacterSerializer

  def id
    object.guid
  end

  def activity
    case object.activity_type
      when 'Image'
        Activity::ImageSerializer
      when 'Character'
        Activity::CharacterSerializer
      when 'Forum::Discussion'
        Activity::DiscussionSerializer
      when 'Media::Comment'
        Activity::CommentSerializer
      else
        ActiveModel::Serializer
    end.new object.activity
  end

  def timestamp
    object.created_at.to_i
  end
end