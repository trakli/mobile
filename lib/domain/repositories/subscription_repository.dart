import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/data/models/plan.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, SubscriptionEntity>> getSubscription();
}
