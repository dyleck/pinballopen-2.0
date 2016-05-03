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

  def build_scores(match)
    match.scores.build
  end
end