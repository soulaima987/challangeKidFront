<?php

namespace App\Controller;

use App\Entity\KidResponse;
use App\Entity\Lesson;
use App\Entity\Question;
use App\Entity\Quiz;
use App\Form\QuizType;
use App\Repository\QuizRepository;
use App\Service\QuizService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use OpenApi\Attributes as OA;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

#[Route('/api/quiz')]
#[OA\Tag(name: 'Quiz')]
class QuizController extends AbstractController
{
    private $quizService;

    public function __construct(QuizService $quizService)
    {
        $this->quizService = $quizService;
    }

    #[Route('/{lesson}', name: 'app_quiz_index', methods: ['GET'])]
    public function index(Lesson $lesson, QuizRepository $quizRepository): JsonResponse
    {
        $listJson = [];
        $list = $quizRepository->findBy(["lesson" => $lesson]);
        foreach ($list as $key => $value) {
            $listJson[$key] = $this->quizService->quizToJson($value);
        }
        return new JsonResponse($listJson);
    }

    #[Route('/{lesson}/new', name: 'app_quiz_new', methods: ['POST'])]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            type: Object::class,
            example: [
                "title" => "quiz1",
            ]
        )
    )]
    public function new(Lesson $lesson, Request $request, EntityManagerInterface $entityManager): JsonResponse
    {
        $data = json_decode($request->getContent(), true);
        $quiz = new Quiz();
        $form = $this->createForm(QuizType::class, $quiz);
        $form->submit($data);
        if ($form->isSubmitted()) {
            $quiz->setLesson($lesson);
            $entityManager->persist($quiz);
            $entityManager->flush();
        }
        return new JsonResponse(true);
    }

    #[Route('/{id}', name: 'app_quiz_show', methods: ['GET'])]
    public function show($id, QuizRepository $quizRepository): JsonResponse
    {
        $quiz = $quizRepository->find($id);
        $quiz = $this->quizService->quizToJson($quiz);
        return new JsonResponse($quiz);
    }

    #[Route('/{id}', name: 'app_quiz_delete', methods: ['DELETE'])]
    public function delete($id, QuizRepository $quizRepository, EntityManagerInterface $entityManager): JsonResponse
    {
        $quiz = $quizRepository->find($id);
        if (!$quiz) {
            throw new NotFoundHttpException('Quiz not found');
        }

        $entityManager->remove($quiz);
        $entityManager->flush();

        return new JsonResponse(['status' => 'The Quiz has been deleted']);
    }
}
