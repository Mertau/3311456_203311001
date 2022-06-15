class FavouriteMoviesApi {
  List<Movies>? movies;

  FavouriteMoviesApi({this.movies});

  FavouriteMoviesApi.fromJson(Map<String, dynamic> json) {
    if (json['movies'] != null) {
      movies = <Movies>[];
      json['movies'].forEach((v) {
        movies!.add(Movies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.movies != null) {
      data['movies'] = this.movies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Movies {
  String? movieName;
  int? outDate;
  String? imgUrl;

  Movies({this.movieName, this.outDate, this.imgUrl});

  Movies.fromJson(Map<String, dynamic> json) {
    movieName = json['movieName'];
    outDate = json['outDate'];
    imgUrl = json['imgUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['movieName'] = this.movieName;
    data['outDate'] = this.outDate;
    data['imgUrl'] = this.imgUrl;
    return data;
  }
}
