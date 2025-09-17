#ifndef CALCULATOR_H
#define CALCULATOR_H

#include <QObject>
#include <QString>
#include <QTimer>

class CalculatorEngine;

class Calculator : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString displayValue READ displayValue WRITE setDisplayValue NOTIFY displayValueChanged)
    Q_PROPERTY(QString resultValue READ resultValue NOTIFY resultValueChanged)

public:
    explicit Calculator(QObject *parent = nullptr);
    ~Calculator();

    QString displayValue() const;
    QString resultValue() const;

public slots:
    void buttonPressed(const QString &buttonText);
    void clear();
    void calculate();
    void handleLongEqualPress();

signals:
    void displayValueChanged(const QString &newValue);
    void resultValueChanged(const QString &newValue);
    void showSecretMenu();

private:
    void setDisplayValue(const QString &newValue);
    void setResultValue(const QString &newValue);

    QString m_displayValue;
    QString m_resultValue;
    CalculatorEngine *m_engine;


    QTimer m_secretCodeTimer;
    QString m_secretCodeInput;
    bool m_waitingForSecretCode;
};

#endif // CALCULATOR_H
