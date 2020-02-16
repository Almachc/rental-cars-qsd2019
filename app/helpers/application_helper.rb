module ApplicationHelper
  def t_model(model_name)
    model_name = model_name.to_s
    if model_name.singularize == model_name
      I18n.t(:one, scope: [:activerecord, :models, model_name])
    else
      I18n.t(:other, scope: [:activerecord, :models, model_name.singularize])
    end
  end

  def t_attribute(attribute, model)
    I18n.t(attribute, scope: [:activerecord, :attributes, model])
  end

  def t_link(link, model = nil)
    if model
      I18n.t("helpers.links.#{link}", model: I18n.t(:one, scope: [:activerecord, :models, model]).downcase)
    else
      I18n.t("helpers.links.#{link}")
    end
  end

  def t_error(attribute, model, error, value = '')
    if error == :blank
      "#{t_attribute(attribute, model)} #{I18n.t(error, scope: [:errors, :messages])}"
    elsif error == :greater_than
      "#{t_attribute(attribute, model)} #{I18n.t(error, count: value, scope: [:errors, :messages])}"
    end
  end
end
