class PagesController < ApplicationController

  def display_form

    render({ :template => "pages_templates/blank_form"})

  end

  def process_inputs

    @the_image = params.fetch("image_param")
    @the_description = params.fetch("description_param")

    render({ :template => "pages_templates/results"})

  end

end
