class SuccessCaseSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :case_image, :url, :case_image_thumb

  def case_image_thumb
    object.case_image(:thumb)
  end

end

