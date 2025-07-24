module ApplicationHelper
  # The RSS feeds that minicast serves are public.  Signed S3 URLs time out, so let's construct
  # a URL that will be public as long as the feed is.
  def public_url(image)
    if Rails.env.production?
      "#{ENV["PUBLIC_S3_URL"]}/#{image.blob.key}"
    else
      image.url
    end
  end
end
