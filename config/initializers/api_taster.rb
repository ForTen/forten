if Rails.env.development?
  ApiTaster.route_path = Rails.root.to_s + "/lib/api_tasters"
end
