<?php

namespace App\Controller;

use App\Entity\Kid;
use App\Entity\KidResponse;
use App\Entity\Quiz;
use App\Form\ResponseType;
use App\Repository\KidResponseRepository;
use App\Service\KidResponseService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use OpenApi\Attributes as OA;
use Symfony\Component\HttpFoundation\JsonResponse;

#[Route('/api/kidResponse')]
#[OA\Tag(name: 'KidResponse')]
class KidResponseController extends AbstractController
{
    private $kidResponseService;

    public function __construct(KidResponseService $kidResponseService)
    {
        $this->kidResponseService = $kidResponseService;
    }

    #[Route('/', name: 'response_index', methods: ['GET'])]
    public function index(KidResponseRepository $responseRepository): JsonResponse
    {
        $listJson = [];
        $list = $responseRepository->findAll();
        foreach ($list as $key => $value) {
            $listJson[$key] = $this->kidResponseService->kidResponseToJson($value);
        }
        return new JsonResponse($listJson);
    }

    #[Route('/{kid}/{quiz}/new', name: 'response_new', methods: ['POST'])]
    public function new(Request $request, Kid $kid, Quiz $quiz, EntityManagerInterface $entityManager): JsonResponse
    {

        $kidResponse = new KidResponse();

        $kidResponse->setQuiz($quiz);
        $kidResponse->setKid($kid);
        $entityManager->persist($kidResponse);
        $entityManager->flush();

        return new JsonResponse(true);
    }

    #[Route('/{id}', name: 'response_show', methods: ['GET'])]
    public function show($id, KidResponseRepository $kidResponseRepository): JsonResponse
    {
        $kidResponse = $kidResponseRepository->find($id);
        $kidResponse = $this->kidResponseService->kidResponseToJson($kidResponse);
        return new JsonResponse($kidResponse);
    }
}
