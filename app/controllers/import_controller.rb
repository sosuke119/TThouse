class ImportController < ApplicationController

  def import_properties_page
    
  end

  def import_properties_page_two
  end

  def import_properties
    if params[:file]
      Property.import(params[:file])
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = "沒有選擇檔案"
      redirect_back(fallback_location: root_path)
    end
  end

  def import_properties_two
    if params[:file]
      Property.import_properties_two(params[:file])
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = "沒有選擇檔案"
      redirect_back(fallback_location: root_path)
    end
  end


end
