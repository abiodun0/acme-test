class User < ApplicationRecord
    has_secure_password
	has_many :hits
    has_many :monthly_hits, ->(time_zone) { where('hits.created_at > ?', Time.now.beginning_of_month.in_time_zone(time_zone).utc) }, class_name: 'Hit'

	def old_count_hits
		start = Time.now.beginning_of_month
		hits = self.hits.where('created_at > ?', start).count
		return hits
  end

  def count_hits
    start = Time.now.beginning_of_month.in_time_zone(self.time_zone).utc
    cache_key = "user_count_hits_#{id}_#{start.to_i}"
    hits_count = Rails.cache.fetch(cache_key, expires_in: 10.seconds) do
        hits.where('created_at > ?', start).count
    end
    return hits_count
  end
end