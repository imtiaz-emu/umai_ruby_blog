require 'action_controller'
require_relative '../models/feedback'
require_relative '../controllers/application_controller'
require_relative '../controllers/concerns/feedback_support'

class FeedbacksController < ApplicationController
  include FeedbackSupport
end
