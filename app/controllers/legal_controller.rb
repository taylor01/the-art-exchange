class LegalController < ApplicationController
  def terms_of_service
    @page_title = "Terms of Service"
  end

  def privacy_policy
    @page_title = "Privacy Policy"
  end
end
