class SuccessCaseSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :url, :case_image, :case_image_thumb, :video_url

  def case_image_thumb
    object.case_image(:thumb)
  end

end

