class SpecialtyShow < ActiveRecord::Base
  include Show

  belongs_to :dj, class_name: "Dj", foreign_key: "coordinator_id"
  has_and_belongs_to_many :djs, dependent: :delete_all

  alias_attribute :coordinator, :dj

  def hosts
    ([coordinator] + djs.sort_by { |dj| dj.try(&:name) }).uniq
  end

  def default_status
    :unassigned
  end

  def dj_id_changed?
    coordinator_id_changed?
  end

  def deal
    h = hosts
    # modify only unassigned or unconfirmed episodes
    unconfirmed_episodes = episodes.reject(&:past?).select do |x|
      x.unassigned? || x.normal?
    end
    unconfirmed_episodes.each_with_index do |ep, inx|
      ep.dj = h[inx % h.count]
      ep.status = :normal
    end

    transaction do 
      unconfirmed_episodes.each(&:save!)
    end
  end

  def with
    if hosts.count == 1
      "with #{dj}"
    else
      h = hosts
      "#{h.count} #{"DJ".pluralize(h.count)} in rotation"
    end
  end

end
