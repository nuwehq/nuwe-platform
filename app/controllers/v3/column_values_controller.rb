class V3::ColumnValuesController < V3::BaseController

  before_filter :find_medical_device
  before_filter :find_column_value, only: [:update, :destroy]
  before_filter :correct_medical_device, only: [:update]
  skip_after_filter :create_stat


  def index
    column_values = @medical_device.column_values
    render json: column_values
  end

  def create
    result = MedicalDeviceColumnsInteractor::ColumnCreation.call medical_device: @medical_device, columns: params[:columns]
    if result.success?
      render json: result.column_values, status: result.status
    else
      render json:{error: {message: result.message}, status: result.status}
    end
  end

  def update
    result = MedicalDeviceColumnsInteractor::UpdateColumn.call column_value: @column_value, column_value_params: column_value_params
    if result.success?
      render json: result.column_value
    else
      render json:{error: {message: result.message}, status: result.status}
    end
  end

  def destroy
    if @column_value.destroy
      render json: {notice: {message: "Column was deleted.", column_value: @column_value}}
    else
      render json: {error: {message: @column_value.errors.full_messages}}, status: :bad_request
    end
  end

  private

  def find_medical_device
    @medical_device = MedicalDevice.find_by_token! params[:medical_device_id]
  end

  def find_column_value
    @column_value = ColumnValue.find(params[:id])
  end

  def correct_medical_device
    unless @column_value.medical_device_id == @medical_device.id
      render json: {error: {message: "Columns don't match medical device."}}, status: :bad_request
    end
  end

  def column_value_params
    params.require(:column_value).permit(:field_name, :type, :read_only, :editor, :visible)
  end
end
