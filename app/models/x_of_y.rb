class XOfY < Phase

  def assign(match)
    user = match.users.first
    flipper = match.flipper
    rounds_played_by_user = self.rounds.joins(:users).where("scores.user_id": user.id)
    matches_played = rounds_played_by_user.map(&:matches).flatten
    flippers_played = matches_played.map(&:flipper)
    if flippers_played.include?(flipper)
      match.destroy
      match = rounds_played_by_user.joins(:flippers).where("matches.flipper_id": flipper.id)[0].matches.first
      if match.scores.first.value.nil?
        return match
      else
        "Wynik na flipperze #{flipper.name} już istnieje"
      end
    elsif flippers_played.count >= self.number_of_rounds
      match.destroy
      "Gracz już zagrał wszystkie przewidziane rundy"
    else
      round = Round.create(matches: [match])
      self.rounds << round
      return ""
    end
  end

  def destroy_match(match)
    match.round.destroy
  end

  def build_scores(match)
    match.scores.build
  end

  def match_if_contains(match)
    new_match_flipper = match.flipper
    new_match_user = match.scores.first.user
    rounds_played_by_user = self.rounds.joins(:flippers, :users).where(
        "scores.user_id": new_match_user.id,
        "matches.flipper_id": new_match_flipper.id).first
    if rounds_played_by_user
      rounds_played_by_user.matches.first
    else
      nil
    end
  end

  def update_scores(match, params)
    params[:match][:scores_attributes]["0"][:value].to_i
  end
end