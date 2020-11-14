class Search {
  final List<Teams> teams;

  Search({this.teams});

  factory Search.fromJson(Map<String, dynamic> parsedJson) {
    var team = parsedJson['teams'] as List;
    print(team.runtimeType);
    List<Teams> teamsList = team.map((i) => Teams.fromJson(i)).toList();

    return Search(teams: teamsList);
  }
}

class Teams {
  String strTeam;
  String strAlternate;
  String strLeague;
  String strStadium;
  String strDescriptionES;
  String strTeamLogo;

  Teams(
      {this.strTeam,
      this.strAlternate,
      this.strDescriptionES,
      this.strLeague,
      this.strStadium,
      this.strTeamLogo});

  factory Teams.fromJson(Map<String, dynamic> parsedJson) {
    return Teams(
        strTeam: parsedJson['strTeam'],
        strAlternate: parsedJson['strAlternate'],
        strDescriptionES: parsedJson['strDescriptionES'],
        strLeague: parsedJson['strLeague'],
        strStadium: parsedJson['strStadium'],
        strTeamLogo: parsedJson['strTeamLogo']);
  }
}
