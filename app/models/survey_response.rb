class SurveyResponse < ActiveRecord::Base
  belongs_to :surveyable, :polymorphic => true
  belongs_to :survey
  belongs_to :user
  scope :active, where("expires_on > ?", Time.now)
  scope :expired, where("expires_on < ?", Time.now)
  scope :taken, where("response != ? or note != ?", 0, nil)
  scope :not_taken, where(:response => nil, :note => nil)
  scope :during, lambda { |time1, time2| where("updated_at BETWEEN ? and ?", time1, time2)} 
  validates_presence_of :survey_id, :user_id, :expires_on, :surveyable_id, :surveyable_type
  validates_uniqueness_of :code
  
  def self.trends
    group("date(survey_responses.created_at)").average(:response)
  end

  def self.trending(num=6)
    s= self.trends
    t = s.to_a
    t[0..6].reverse
  end

end
