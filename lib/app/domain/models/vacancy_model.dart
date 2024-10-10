import 'package:flutter/foundation.dart';

class Vacancy {
  final String? id;
  final String title;
  final String education;
  final String experience;
  final List<String> skills;
  final List<String> aceptedDisabilities;
  final String salary;
  final String description;
  final String? owner;
  final List<Map<String, dynamic>>? postulants;

  Vacancy({
    this.id,
    required this.title,
    required this.education,
    required this.experience,
    required this.skills,
    required this.aceptedDisabilities,
    required this.salary,
    required this.description,
    this.owner,
    this.postulants,
  });

  factory Vacancy.fromJson(String id, Map<String, dynamic> json) {
    return Vacancy(
      id: id,
      title: json['title'] ?? '',
      education: json['education'] ?? '',
      experience: json['experience'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      aceptedDisabilities: List<String>.from(json['aceptedDisabilities'] ?? []),
      salary: json['salary'] ?? '',
      description: json['description'] ?? '',
      owner: json['owner'] ?? '',
      postulants: List<Map<String, dynamic>>.from(json['postulants'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'education': education,
      'experience': experience,
      'skills': skills,
      'aceptedDisabilities': aceptedDisabilities,
      'salary': salary,
      'description': description,
      'owner': owner,
      'postulants': postulants,
    };
  }

  Vacancy copyWith({
    String? title,
    String? education,
    String? experience,
    List<String>? skills,
    List<String>? aceptedDisabilities,
    String? salary,
    String? description,
    String? owner,
    List<Map<String, dynamic>>? postulants,
  }) {
    return Vacancy(
      id: id,
      title: title ?? this.title,
      education: education ?? this.education,
      experience: experience ?? this.experience,
      skills: skills ?? this.skills,
      aceptedDisabilities: aceptedDisabilities ?? this.aceptedDisabilities,
      salary: salary ?? this.salary,
      description: description ?? this.description,
      owner: owner ?? this.owner,
      postulants: postulants ?? this.postulants,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Vacancy &&
        other.id == id &&
        other.title == title &&
        other.education == education &&
        other.experience == experience &&
        listEquals(other.skills, skills) &&
        listEquals(other.aceptedDisabilities, aceptedDisabilities) &&
        other.salary == salary &&
        other.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode;

  @override
  String toString() {
    return 'Vacancy(id: $id, title: $title, education: $education, experience: $experience, skills: $skills, aceptedDisabilities: $aceptedDisabilities, salary: $salary, description: $description, owner: $owner, postulants: $postulants)';
  }

  bool containsSkill(String skill) {
    return skills.contains(skill);
  }

  bool containsDisability(String disability) {
    return aceptedDisabilities.contains(disability);
  }

  bool hasNoSkills() {
    return skills.isEmpty;
  }

  bool hasNoDisabilities() {
    return aceptedDisabilities.isEmpty;
  }

  bool hasNoPostulants() {
    return postulants!.isEmpty;
  }

  bool isPostulant(String id) {
    if (postulants == null) return false;
    return postulants!.any((postulant) => postulant['id'] == id);
  }

  String getStatus(String id) {
    if (postulants == null) return '';
    final postulant =
        postulants!.firstWhere((postulant) => postulant['id'] == id);
    return postulant['status'];
  }

  bool isComplete() {
    return title.isNotEmpty &&
        education.isNotEmpty &&
        experience.isNotEmpty &&
        skills.isNotEmpty &&
        aceptedDisabilities.isNotEmpty &&
        salary.isNotEmpty &&
        description.isNotEmpty;
  }

  bool notSame(Object other) {
    return !identical(this, other) ||
        other is! Vacancy ||
        other.id != id ||
        other.title != title ||
        other.education != education ||
        other.experience != experience ||
        !listEquals(other.skills, skills) ||
        !listEquals(other.aceptedDisabilities, aceptedDisabilities) ||
        other.salary != salary ||
        other.description != description;
  }
}
