import 'package:flutter_test/flutter_test.dart';
import 'package:service_platform/core/api/api_helpers.dart';

void main() {
  group('ApiHelpers', () {
    group('parseListResponse', () {
      test('should parse response with data key', () {
        // Arrange
        final response = {
          'data': [
            {'id': '1', 'name': 'Item 1'},
            {'id': '2', 'name': 'Item 2'},
          ],
          'meta': {'total': 2},
        };

        // Act
        final result = ApiHelpers.parseListResponse(response);

        // Assert
        expect(result, isA<List>());
        expect(result.length, 2);
        expect(result[0]['id'], '1');
        expect(result[1]['name'], 'Item 2');
      });

      test('should parse direct array response', () {
        // Arrange
        final response = [
          {'id': '1', 'name': 'Item 1'},
          {'id': '2', 'name': 'Item 2'},
        ];

        // Act
        final result = ApiHelpers.parseListResponse(response);

        // Assert
        expect(result, isA<List>());
        expect(result.length, 2);
        expect(result[0]['id'], '1');
      });

      test('should return empty list for null response', () {
        // Act
        final result = ApiHelpers.parseListResponse(null);

        // Assert
        expect(result, isA<List>());
        expect(result.isEmpty, true);
      });

      test('should return empty list for empty data', () {
        // Arrange
        final response = {'data': []};

        // Act
        final result = ApiHelpers.parseListResponse(response);

        // Assert
        expect(result, isA<List>());
        expect(result.isEmpty, true);
      });

      test('should handle nested data structures', () {
        // Arrange
        final response = {
          'data': [
            {
              'id': '1',
              'user': {'name': 'John'},
              'posts': [
                {'title': 'Post 1'}
              ]
            },
          ],
        };

        // Act
        final result = ApiHelpers.parseListResponse(response);

        // Assert
        expect(result.length, 1);
        expect(result[0]['user']['name'], 'John');
        expect(result[0]['posts'][0]['title'], 'Post 1');
      });
    });

    group('parseNumber', () {
      test('should parse int to double', () {
        expect(ApiHelpers.parseNumber(42), 42.0);
      });

      test('should parse double directly', () {
        expect(ApiHelpers.parseNumber(42.5), 42.5);
      });

      test('should parse string to double', () {
        expect(ApiHelpers.parseNumber('42.5'), 42.5);
      });

      test('should parse string int to double', () {
        expect(ApiHelpers.parseNumber('42'), 42.0);
      });

      test('should return 0.0 for invalid string', () {
        expect(ApiHelpers.parseNumber('invalid'), 0.0);
      });

      test('should return 0.0 for null', () {
        expect(ApiHelpers.parseNumber(null), 0.0);
      });

      test('should handle negative numbers', () {
        expect(ApiHelpers.parseNumber(-42), -42.0);
        expect(ApiHelpers.parseNumber('-42.5'), -42.5);
      });

      test('should handle zero', () {
        expect(ApiHelpers.parseNumber(0), 0.0);
        expect(ApiHelpers.parseNumber('0'), 0.0);
      });

      test('should handle decimal strings without leading zero', () {
        expect(ApiHelpers.parseNumber('.5'), 0.5);
      });
    });

    group('parseBool', () {
      test('should parse bool directly', () {
        expect(ApiHelpers.parseBool(true), true);
        expect(ApiHelpers.parseBool(false), false);
      });

      test('should parse "true" string', () {
        expect(ApiHelpers.parseBool('true'), true);
        expect(ApiHelpers.parseBool('TRUE'), true);
      });

      test('should parse "1" as true', () {
        expect(ApiHelpers.parseBool('1'), true);
        expect(ApiHelpers.parseBool(1), true);
      });

      test('should parse "false" string', () {
        expect(ApiHelpers.parseBool('false'), false);
        expect(ApiHelpers.parseBool('FALSE'), false);
      });

      test('should parse "0" as false', () {
        expect(ApiHelpers.parseBool('0'), false);
        expect(ApiHelpers.parseBool(0), false);
      });

      test('should return false for null', () {
        expect(ApiHelpers.parseBool(null), false);
      });

      test('should return false for invalid string', () {
        expect(ApiHelpers.parseBool('invalid'), false);
      });
    });

    group('formatError', () {
      test('should format simple error message', () {
        final error = {'message': 'Something went wrong'};
        expect(ApiHelpers.formatError(error), 'Something went wrong');
      });

      test('should format error with array of messages', () {
        final error = {
          'message': ['Error 1', 'Error 2']
        };
        expect(ApiHelpers.formatError(error), 'Error 1, Error 2');
      });

      test('should handle error field', () {
        final error = {'error': 'Bad request'};
        expect(ApiHelpers.formatError(error), 'Bad request');
      });

      test('should return default message for unknown error', () {
        final error = {'unknown': 'value'};
        expect(
          ApiHelpers.formatError(error),
          contains('Неизвестная ошибка'),
        );
      });

      test('should handle null error', () {
        expect(
          ApiHelpers.formatError(null),
          contains('Неизвестная ошибка'),
        );
      });
    });
  });
}
