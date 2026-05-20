require 'sequel'

DB.create_table? :links do
  primary_key :id
  String   :name, unique: true, null: false
  String   :url, null: false, text: true
  String   :category, null: true
  String   :tags, null: true  # comma-separated
  Integer  :hits, default: 0, null: false
  DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
  DateTime :updated_at, null: true
  index :name
  index :category
  index :hits
end

class Link < Sequel::Model
  def before_create
    self.hits       ||= 0
    self.created_at ||= Time.now
    super
  end

  def before_update
    self.updated_at = Time.now
    super
  end

  # Atomically increment hit counter
  def hit!
    self.class.where(id: id).update(hits: Sequel[:hits] + 1)
    refresh
  end

  def tag_list
    (tags || '').split(',').map(&:strip).reject(&:empty?)
  end

  def short_url(base_url)
    "#{base_url}/#{name}"
  end

  def validate
    super
    errors.add(:name, 'cannot be empty') if !name || name.to_s.strip.empty?
    errors.add(:url,  'cannot be empty') if !url  || url.to_s.strip.empty?
    if name && name.match?(/[\/\s]/)
      errors.add(:name, 'cannot contain slashes or spaces')
    end
    if url && !url.match?(%r{\Ahttps?://}i)
      errors.add(:url, 'must start with http:// or https://')
    end
  end
end
