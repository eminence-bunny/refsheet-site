Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  # User Mutations
  field :deleteUser, field: Mutations::UserMutations::Delete

  # Images
  field :uploadImage, field: Mutations::ImageMutations::Create
  field :updateImage, field: Mutations::ImageMutations::Update
  field :deleteMedia, field: Mutations::ImageMutations::Destroy

  # Media
  field :addFavorite, field: Mutations::MediaFavoriteMutations::Create
  field :removeFavorite, field: Mutations::MediaFavoriteMutations::Destroy
  field :addComment, field: Mutations::MediaCommentMutations::Create
  field :removeComment, field: Mutations::MediaCommentMutations::Destroy

  # Chat
  field :sendMessage, field: Mutations::MessageMutations::Create
  field :updateConversation, field: Mutations::ConversationMutations::Update

  # Moderation
  field :updateModeration, field: Mutations::ModerationMutations::Update

  # Session
  field :createSession, field: Mutations::SessionMutations::Create
  field :destroySession, field: Mutations::SessionMutations::Destroy

  # Notifications
  field :markAllNotificationsAsRead, field: Mutations::NotificationMutations::ReadAll
  field :readNotification, field: Mutations::NotificationMutations::Read

  #== Character Profiles

  # Character Mutations
  field :updateCharacter, field: Mutations::CharacterMutations::Update
  field :convertCharacter, field: Mutations::CharacterMutations::Convert

  # Profile Section
  field :updateProfileSection, field: Mutations::ProfileSectionMutations::Update
  field :createProfileSection, field: Mutations::ProfileSectionMutations::Create
  field :deleteProfileSection, field: Mutations::ProfileSectionMutations::Delete

  # Profile Widget
  field :updateProfileWidget, field: Mutations::ProfileWidgetMutations::Update
  field :createProfileWidget, field: Mutations::ProfileWidgetMutations::Create
  field :deleteProfileWidget, field: Mutations::ProfileWidgetMutations::Delete

  #== Forums

  field :createForum, field: Mutations::ForumMutations::Create
  field :updateForum, field: Mutations::ForumMutations::Update
  field :postReply, field: Mutations::ForumPostMutations::Create

  # Activity Feed
  field :createActivity, field: Mutations::ActivityMutations::Create
end
