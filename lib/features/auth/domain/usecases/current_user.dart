import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements UseCase<User, NoParams> {
  final AuthRebository authRebository;

  CurrentUser(this.authRebository);
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRebository.currentUser();
  }
}
