#include "calculator.h"
#include "calculator_engine.h"
#include <QDebug>

Calculator::Calculator(QObject *parent) : QObject(parent), m_engine(new CalculatorEngine())
{
    m_displayValue = "";
    m_resultValue = "0";

    m_secretCodeTimer.setSingleShot(true);
    m_secretCodeTimer.setInterval(5000);
    connect(&m_secretCodeTimer, &QTimer::timeout, this, [this]() {
        qDebug() << "Secret code input timeout";
        m_waitingForSecretCode = false;
        m_secretCodeInput = "";
    });

    m_waitingForSecretCode = false;
    m_secretCodeInput = "";
}

Calculator::~Calculator()
{
    delete m_engine;
}

QString Calculator::displayValue() const
{
    return m_displayValue;
}

QString Calculator::resultValue() const
{
    return m_resultValue;
}

void Calculator::setDisplayValue(const QString &newValue)
{
    if (m_displayValue != newValue) {
        m_displayValue = newValue;
        emit displayValueChanged(m_displayValue);
    }
}

void Calculator::setResultValue(const QString &newValue)
{
    if (m_resultValue != newValue) {
        m_resultValue = newValue;
        emit resultValueChanged(m_resultValue);
    }
}

void Calculator::handleLongEqualPress()
{
    qDebug() << "Handle long equal press";
    m_waitingForSecretCode = true;
    m_secretCodeInput = "";
    m_secretCodeTimer.start();
    qDebug() << "Ждем ввод комбинации 123...";
}

void Calculator::buttonPressed(const QString &buttonText)
{
    if (m_waitingForSecretCode) {
        qDebug() << "Processing secret code input:" << buttonText;
        if (buttonText >= "0" && buttonText <= "9") {
            m_secretCodeInput += buttonText;
            qDebug() << "Current secret code:" << m_secretCodeInput;

            if (m_secretCodeInput == "123") {
                qDebug() << "Secret code correct!";
                emit showSecretMenu();
                m_waitingForSecretCode = false;
                m_secretCodeTimer.stop();
            }
        }
        return;
    }
    if (buttonText == "=" || buttonText == "C") {
        return;
    }

    if (buttonText == "±") {
        // Изменение знака
        if (m_displayValue.isEmpty() || m_displayValue == "0") {
            setDisplayValue("-");
        } else if (m_displayValue.startsWith("-")) {
            setDisplayValue(m_displayValue.mid(1));
        } else {
            setDisplayValue("-" + m_displayValue);
        }
        return;
    }

    if (buttonText == "%") {
        // Процент
        if (!m_resultValue.isEmpty()) {
            double value = m_resultValue.toDouble();
            setResultValue(QString::number(value / 100.0));
        }
        return;
    }

    if (buttonText == "()") {
        int openBrackets = 0;
        int closeBrackets = 0;

        for (int i = 0; i < m_displayValue.length(); i++) {
            if (m_displayValue[i] == '(') openBrackets++;
            else if (m_displayValue[i] == ')') closeBrackets++;
        }

        QChar lastChar = m_displayValue.isEmpty() ? QChar() : m_displayValue[m_displayValue.length()-1];
        if (m_displayValue.isEmpty() ||
            lastChar == '+' || lastChar == '-' || lastChar == '*' || lastChar == '/' ||
            lastChar == '(' || openBrackets == closeBrackets) {
            setDisplayValue(m_displayValue + "(");
        }
        else if (openBrackets > closeBrackets &&
                 (lastChar.isDigit() || lastChar == ')')) {
            setDisplayValue(m_displayValue + ")");
        }
        return;
    }

    if (m_displayValue == "0" && buttonText != ".") {
        setDisplayValue(buttonText);
    } else {
        setDisplayValue(m_displayValue + buttonText);
    }
}

void Calculator::clear()
{
    setDisplayValue("");
    setResultValue("0");
}

void Calculator::calculate()
{
    if (m_displayValue.isEmpty()) {
        setResultValue("0");
        return;
    }

    try {
        double result = m_engine->evaluateExpression(m_displayValue);
        setResultValue(QString::number(result, 'g', 10));
    } catch (const std::exception& e) {
        setResultValue("Error");
    } catch (...) {
        setResultValue("Error");
    }
}
