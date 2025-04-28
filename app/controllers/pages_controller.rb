class PagesController < ApplicationController
  def display_form
    render({ :template => "pages_templates/blank_form" })
  end

  def process_inputs
    @the_image = params.fetch("image_param", false)
    @the_description = params.fetch("description_param")

    c = OpenAI::Chat.new
    c.system("You are an expert nutritionist. The user will give you an image and/or desciption of a meal. Your job is to estimate the macronutrients in it.")

    c.user(@the_description)
    c.schema = '{
      "name": "nutrition_info",
      "schema": {
        "type": "object",
        "properties": {
          "carbohydrates": {
            "type": "number",
            "description": "Amount of carbohydrates in grams."
          },
          "protein": {
            "type": "number",
            "description": "Amount of protein in grams."
          },
          "fat": {
            "type": "number",
            "description": "Amount of fat in grams."
          },
          "total_calories": {
            "type": "number",
            "description": "Total calories in kcal."
          },
          "notes": {
            "type": "string",
            "description": "A breakdown of how you arrived at the values, and additional notes."
          }
        },
        "required": [
          "carbohydrates",
          "protein",
          "fat",
          "total_calories",
          "notes"
        ],
        "additionalProperties": false
      },
      "strict": true
    }'

    @structured_output = c.assistant!

    @g_carbs = @structured_output.fetch("carbohydrates")
    @g_protein = @structured_output.fetch("protein")
    @g_fat = @structured_output.fetch("fat")
    @kcal = @structured_output.fetch("total_calories")

    render({ :template => "pages_templates/results" })
  end
end
