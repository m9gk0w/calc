#ifndef CALCULATOR_ENGINE_H
#define CALCULATOR_ENGINE_H

#include <QStack>
#include <QString>
#include <QChar>
#include <cmath>
#include <stdexcept>
#include <QRegularExpression>

class CalculatorEngine
{
public:
    double evaluateExpression(QString expression) {
        expression = expression.replace(" ", "");

        if (!areParenthesesBalanced(expression)) {
            throw std::runtime_error("Несбалансированные скобки");
        }

        QStack<double> values;
        QStack<QChar> ops;

        for (int i = 0; i < expression.length(); i++) {
            if (expression[i] == ' ') continue;

            if (expression[i] == '(') {
                ops.push(expression[i]);
            }
            else if (expression[i].isDigit() || expression[i] == '.') {
                QString numStr;
                while (i < expression.length() &&
                       (expression[i].isDigit() || expression[i] == '.')) {
                    numStr += expression[i];
                    i++;
                }
                i--;
                values.push(numStr.toDouble());
            }
            else if (expression[i] == ')') {
                while (!ops.empty() && ops.top() != '(') {
                    double val2 = values.top(); values.pop();
                    double val1 = values.top(); values.pop();
                    QChar op = ops.top(); ops.pop();
                    values.push(applyOp(val1, val2, op));
                }
                if (!ops.empty()) ops.pop();
            }
            else {

                if (expression[i] == '-' && (i == 0 || expression[i-1] == '(' ||
                                             isOperator(expression[i-1]))) {

                    values.push(0);
                    ops.push('-');
                    continue;
                }

                while (!ops.empty() && precedence(ops.top()) >= precedence(expression[i])) {
                    double val2 = values.top(); values.pop();
                    double val1 = values.top(); values.pop();
                    QChar op = ops.top(); ops.pop();
                    values.push(applyOp(val1, val2, op));
                }
                ops.push(expression[i]);
            }
        }

        while (!ops.empty()) {
            double val2 = values.top(); values.pop();
            double val1 = values.top(); values.pop();
            QChar op = ops.top(); ops.pop();
            values.push(applyOp(val1, val2, op));
        }

        if (values.empty()) {
            throw std::runtime_error("Неверное выражение");
        }

        return values.top();
    }

private:
    bool isOperator(QChar ch) {
        return ch == '+' || ch == '-' || ch == '*' || ch == '/';
    }

    bool areParenthesesBalanced(const QString &expr) {
        int balance = 0;
        for (QChar ch : expr) {
            if (ch == '(') balance++;
            else if (ch == ')') balance--;

            if (balance < 0) return false;
        }
        return balance == 0;
    }

    int precedence(QChar op) {
        if (op == '+' || op == '-') return 1;
        if (op == '*' || op == '/') return 2;
        return 0;
    }

    double applyOp(double a, double b, QChar op) {
        switch(op.unicode()) {
        case '+': return a + b;
        case '-': return a - b;
        case '*': return a * b;
        case '/':
            if (b == 0) throw std::runtime_error("Деление на ноль");
            return a / b;
        }
        throw std::runtime_error("Неверный оператор");
    }
};

#endif // CALCULATOR_ENGINE_H
