require 'active_support/core_ext/enumerable.rb'

# An arbitrary grouping of users, initiated by one user who is the owner.
class Team < ActiveRecord::Base

  validates :name, presence: true
  validates :activity_goal, inclusion: { in: 0..100 }, allow_nil: true
  validates :nutrition_goal, inclusion: { in: 0..100 }, allow_nil: true
  validates :biometric_goal, inclusion: { in: 0..100 }, allow_nil: true

  has_many :memberships
  has_many :users, through: :memberships
  has_many :owners, -> { where("memberships.owner" => true) }, through: :memberships, source: :user

  has_many :historical_scores, as: :history
  has_many :achievements, -> { order(created_at: :asc) }
  has_many :invitations
  has_many :team_notifications

  belongs_to :application, class_name: 'Doorkeeper::Application'

  def activity_score
    if users.present?
      act_score = []
      activity_count = 0
      users.find_all do |user|
        if user.historical_scores.where(date: Date.yesterday).present?
          act_score << user.historical_scores.where(date: Date.yesterday).order(:created_at).last.activity
          activity_count += 1
        end
      end
      if act_score.sum(&:to_i) == 0
        return 0
      else
        act_score.sum(&:to_i) / activity_count
      end
    else
      return 0
    end
  end

  def nutrition_score
    if users.present?
      nutri_score = []
      nutrition_count = 0
      users.find_all do |user|
        if user.historical_scores.where(date: Date.yesterday).present?
          nutri_score << user.historical_scores.where(date: Date.yesterday).order(:created_at).last.nutrition
          nutrition_count += 1
        end
      end
      if nutri_score.sum(&:to_i) == 0
        return 0
      else
        nutri_score.sum(&:to_i) / nutrition_count
      end
    else
      return 0
    end
  end

  def biometric_score
    if users.present?
      bio_score = []
      biometric_count = 0
      users.find_all do |user|
        if user.historical_scores.where(date: Date.yesterday).present?
          bio_score << user.historical_scores.where(date: Date.yesterday).order(:created_at).last.biometric
          biometric_count += 1
        end
      end
      if bio_score.sum(&:to_i) == 0
        return 0
      else
        bio_score.sum(&:to_i) / biometric_count
      end
    else
      return 0
    end
  end

  def nu_score
    a = activity_score || 0
    b = biometric_score || 0
    n = nutrition_score || 0
    (a+b+n) / 3
  end
end
