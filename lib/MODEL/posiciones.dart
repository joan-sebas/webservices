class Competition {
  Standings standings;

  Competition(this.standings);

  Competition.fromJson(Map<String, dynamic> json) {
    standings = json['standings'];
  }
}

class Standings {
  Tables tables;

  Standings(this.tables);

  Standings.fromJson(Map<String, dynamic> json) {
    tables = json['standings'];
  }
}

class Tables {
  String position;
  Team team;
  String pg;
  String w;
  String d;
  String l;
  String points;
  String goalsFor;
  String goalAgain;
  String gd;
  Tables(this.position, this.team, this.pg, this.w, this.d, this.l, this.points,
      this.goalsFor, this.goalAgain, this.gd);
  Tables.fromJson(Map<String, dynamic> json) {
    position = json['position'];
    team = json['team'];
    pg = json['playedGames'];
    w = json['won'];
    d = json['draw'];
    l = json['lost'];
    points = json['points'];
    goalsFor = json['goalsFor'];
    goalAgain = json['goalsAgainst'];
    gd = json['goalDiffrence'];
  }
}

class Team {
  String id;
  String name;
  Team(this.id, this.name);
  Team.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
