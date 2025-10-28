import 'package:MegaObra/utils/json_serializable.dart';
import 'package:MegaObra/models/user.dart';
import 'package:MegaObra/models/project.dart';

class ProjectCompactView implements JsonSerializable {
  final Project project;
  final List<User> employees;
  final User responsible;
  final User creator;
  final double cost;

  const ProjectCompactView({
    required this.project,
    required this.employees,
    required this.responsible,
    required this.creator,
    required this.cost,
  });

  factory ProjectCompactView.fromJson(Map<String, dynamic> json) {
    return ProjectCompactView(
      project: Project.fromJson(json['project'] as Map<String, dynamic>),
      employees: (json['employees'] as List<dynamic>).map((e) => User.fromJson(e as Map<String, dynamic>)).toList(),
      responsible: User.fromJson(json['responsible'] as Map<String, dynamic>),
      creator: User.fromJson(json['creator'] as Map<String, dynamic>),
      cost: (json['cost'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'project': project.toJson(),
      'employees': employees.map((e) => e.toJson()).toList(),
      'responsible': responsible.toJson(),
      'creator': creator.toJson(),
      'cost': cost,
    };
  }
}
