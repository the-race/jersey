class User
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :races

  rolify

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  validates_presence_of :email
  validates_presence_of :encrypted_password

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  # run 'rake db:mongoid:create_indexes' to create indexes
  index({ email: 1 }, { unique: true, background: true })

  field :name, :type => String
  field :athlete_number, :type => String, :default => ""

  validates_presence_of :name
  attr_accessible :role_ids, :as => :admin
  attr_accessible :name, :athlete_number, :email, :password,
                  :password_confirmation, :remember_me,
                  :created_at, :updated_at

  def new_race
    races.new
  end
end
