require "measurement/engine"
require "measurement/model"

require "measurement/bmi_calculator"
require "measurement/bmr_calculator"
require "measurement/dcn_calculator"
require "measurement/gda_calculator"

require "measurement/humanapi"
require "measurement/moves"
require "measurement/withings"
require "measurement/fitbit"
require "measurement/historical_worker"

# This namespace is for working with measurements such as height and weight.
# These measurements could come in through external APIs or they could be
# taken by our users directly.
#
# Measurements form the core of the NuScore system, as all scores derive
# from measurements.
module Measurement
end
