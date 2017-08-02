#Loop Through Each Question
$LoopQuestion = 10
$StopAtQuestionNumber = 132

#Loop x Amount Of times For A Given Question, Keep Going Till You Reach Quesiton Number
#Question Counter
For($QuestionNumberLoopCounter = 1; $QuestionNumberLoopCounter -le $StopAtQuestionNumber; $QuestionNumberLoopCounter++)
{
	#Question Looper
	For($QuestionLoopCounter = 1; $QuestionLoopCounter -le $LoopQuestion; $QuestionLoopCounter++)
	{
		#Write The Same Question x Times
		Write-Host "Question $QuestionNumberLoopCounter"
	}
}
