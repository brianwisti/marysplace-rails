module CheckinsHelper
  def checkin_clue(checkin)
    if checkin.is_valid
      'success'
    else
      'error'
    end
  end
end
