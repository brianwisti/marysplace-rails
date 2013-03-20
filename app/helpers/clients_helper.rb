module ClientsHelper
  def small_avatar_of(client)
    default_url = "https://s3.amazonaws.com/elasticbeanstalk-us-east-1-820256515611/marys-place/avatars/avatar-blank-small.png"
    if can? :show, client
      link_to image_tag(default_url), client
    else
      image_tag(default_url)
    end
  end

end
