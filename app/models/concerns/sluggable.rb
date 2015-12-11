module Sluggable
  extend ActiveSupport::Concern

  def slug_candidates
    try(:name_group)
    [
      :name,
      :slug_hex
    ]
  end

  def slug_hex
    slug = normalize_friendly_id(name)
    begin
      hexed = "#{slug}-#{SecureRandom.hex(6)}"
    end while self.class.exists?(slug: hexed)
    hexed
  end
end
