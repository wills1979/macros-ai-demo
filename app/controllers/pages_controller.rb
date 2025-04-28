class PagesController < ApplicationController

  def display_form

    render({ :template => "pages_templates/blank_form"})

  end

end
