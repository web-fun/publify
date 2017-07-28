class Admin::TextfiltersController < Admin::BaseController
  def macro_help
    @macro = TextFilterPlugin.available_filters.find { |filter| filter.short_name == params[:id] }
    render html: CommonMarker.render_html(@macro.help_text, :DEFAULT)
  end
end
