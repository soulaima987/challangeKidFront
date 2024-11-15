<?php

namespace App\Controller;

use App\Entity\Reaction;
use App\Form\ReactionType;
use App\Repository\ReactionRepository;
use App\Service\ReactionService;
use Doctrine\ORM\EntityManagerInterface;
use Nelmio\ApiDocBundle\Annotation\Model;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use OpenApi\Attributes as OA;
use Symfony\Component\HttpFoundation\JsonResponse;

#[Route('/api/reaction')]
#[OA\Tag(name: 'Reaction')]
class ReactionController extends AbstractController
{
    private $reactionService;

    public function __construct(ReactionService $reactionService)
    {
        $this->reactionService = $reactionService;
    }

    #[Route('/', name: 'reaction_index', methods: ['GET'])]
    public function index(ReactionRepository $reactionRepository): Response
    {
        $listJson = [];
        $list = $reactionRepository->findAll();
        foreach ($list as $key => $value) {
            $listJson[$key] = $this->reactionService->serialize($value);
        }
        return new JsonResponse($listJson);
    }

    #[Route('/new', name: 'reaction_new', methods: ['POST'])]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            type: Object::class,
            example: [
                "type" => "Like",
            ]
        )
    )]
    public function new(Request $request, EntityManagerInterface $entityManager): JsonResponse
    {
        $data = json_decode($request->getContent(), true);

        $reaction = new Reaction();
        $form = $this->createForm(ReactionType::class, $reaction);
        $form->submit($data);

        if ($form->isSubmitted()) {
            $entityManager->persist($reaction);
            $entityManager->flush();

            return new JsonResponse('Reaction Added Successfully');
        }

        return new JsonResponse('An Error has occured');
    }

    #[Route('/{id}', name: 'reaction_delete', methods: ['DELETE'])]
    public function delete(Request $request, Reaction $reaction, EntityManagerInterface $entityManager): Response
    {
        if ($this->isCsrfTokenValid('delete' . $reaction->getId(), $request->getPayload()->getString('_token'))) {
            $entityManager->remove($reaction);
            $entityManager->flush();
        }

        return $this->redirectToRoute('reaction_index', [], Response::HTTP_SEE_OTHER);
    }
}
