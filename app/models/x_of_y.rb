class XOfY < Phase

  def assign(match)
    if !self.tournament.flippers.include?(match.flipper)
      return "Flipper nie bierze udziału w turnieju"
    end
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

  def user_points(user)
    max = max_points
    total_points = 0
    flippers_played_with_scores(user).each do |entry|
      total_points += points_for_flipper(entry)
    end
    total_points
  end

  def user_games_played(user)
    matches.joins(:users, :scores).where("users.id": user.id).where.not("scores.value": nil).count
  end

  def flippers_played_with_scores(user)
    entries = matches.joins(:users, :scores).where("users.id": user.id).where.not("scores.value": nil).select("matches.flipper_id", "scores.value")
    entries.map {|field| {flipper: Flipper.find_by(id: field.flipper_id), score: field.value}}
  end

  def flippers_game_count
    flippers = []
    self.tournament.flippers.each do |flipper|
      flippers << {name: flipper.name, count: self.matches.where("matches.flipper_id": flipper.id).
                                                  joins(:scores).where.not("scores.value": nil).count}
    end
    flippers
  end

  def points_for_flipper(flipper_score)
    max_points - matches.joins(:scores).where("scores.value > ?", flipper_score[:score]).
                    where("matches.flipper_id": flipper_score[:flipper].id).count
  end

  def max_points
    self.users.count
  end

  def compare(a,b)
    if a[:points] < b[:points]
      return -1
    elsif a[:points] > b[:points]
      return 1
    else
      a_flipper_points = flippers_played_with_scores(a[:user]).map{|f| points_for_flipper(f)}.sort.reverse
      b_flipper_points = flippers_played_with_scores(b[:user]).map{|f| points_for_flipper(f)}.sort.reverse
      if a_flipper_points.length == b_flipper_points.length
        a_flipper_points.each_with_index do |a_val, index|
          if a_val < b_flipper_points[index]
            return -1
          elsif a_val > b_flipper_points[index]
            return 1
          end
        end
        return 0
      elsif a_flipper_points.length < b_flipper_points.length
        return 1
      else
        return -1
      end
    end
  end
end