Types::NotificationType = GraphQL::ObjectType.define do
  name "Notification"
  interfaces [Interfaces::ApplicationRecordInterface]

  field :type, types.String
  field :title, types.String
  field :icon, types.String
  field :href, types.String
  field :tag, types.String

  field :read_at, types.Int do
    resolve -> (obj, _args, _ctx) {
      obj.read_at&.to_i
    }
  end
end
