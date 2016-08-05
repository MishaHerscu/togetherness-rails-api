#
class User < ActiveRecord::Base
  include Authentication
  attr_accessor :avatar
  has_many :examples, inverse_of: :user, dependent: :destroy
  has_many :attraction_suggestions, inverse_of: :user, dependent: :destroy
  has_many :user_tags, inverse_of: :user, dependent: :destroy
  has_many :user_attractions, inverse_of: :user, dependent: :destroy
  has_many :trips, inverse_of: :user, dependent: :destroy
  has_many :attendances, inverse_of: :user, dependent: :destroy

  has_attached_file :avatar, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }

  validates_attachment_content_type :avatar, content_type: %r{/\Aimage\/.*\Z/}
  def rename_avatar
    self.avatar.instance_write :file_name, "#{Time.now.to_i.to_s}.png"
  end

  before_post_process :rename_avatar
end
