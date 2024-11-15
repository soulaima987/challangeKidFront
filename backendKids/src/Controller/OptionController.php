<?php

namespace App\Controller;

use App\Entity\Option;
use App\Entity\Question;
use App\Form\OptionType;
use App\Repository\OptionRepository;
use App\Service\OptionService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use OpenApi\Attributes as OA;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

#[Route('/api/option')]
#[OA\Tag(name: 'Option')]
class OptionController extends AbstractController
{
    private $optionService;

    public function __construct(OptionService $optionService)
    {
        $this->optionService = $optionService;
    }

    #[Route('/{question}', name: 'option_index', methods: ['GET'])]
    public function index(Question $question, OptionRepository $optionRepository): JsonResponse
    {
        $listJson = [];
        $list = $optionRepository->findBy(['question' => $question]);
        foreach ($list as $key => $value) {
            $listJson[$key] = $this->optionService->optionToJson($value);
        }
        return new JsonResponse($listJson);
    }

    #[Route('/{question}/new', name: 'option_new', methods: ['POST'])]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            type: Object::class,
            example: [
                "type" => "true",
                "content" => "this is the content of the first option",
            ]
        )
    )]
    public function new(Question $question, Request $request, EntityManagerInterface $entityManager): JsonResponse
    {
        $data = json_decode($request->getContent(), true);

        $option = new Option();
        $form = $this->createForm(OptionType::class, $option);
        $form->submit($data);

        if ($form->isSubmitted()) {
            $option->setQuestion($question);
            $entityManager->persist($option);
            $entityManager->flush();
        }

        return new JsonResponse(true);
    }

    #[Route('/{id}', name: 'option_show', methods: ['GET'])]
    public function show($id, OptionRepository $optionRepository): JsonResponse
    {
        $option = $optionRepository->find($id);
        $option = $this->optionService->optionToJson($option);
        return new JsonResponse($option);
    }

    #[Route('/{id}/edit', name: 'option_edit', methods: ['PUT'])]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            type: Object::class,
            example: [
                "type" => "false",
                "content" => "this is the content of the first option"
            ]
        )
    )]
    public function edit($id, Request $request, OptionRepository $optionRepository, EntityManagerInterface $entityManager): JsonResponse
    {
        $option = $optionRepository->find($id);

        $data = json_decode($request->getContent(), true);
        $form = $this->createForm(OptionType::class, $option);
        $form->submit($data);

        if ($form->isSubmitted()) {
            $entityManager->persist($option);
            $entityManager->flush();

            return new JsonResponse(['status' => 'Option updated successfully']);
        }

        return new JsonResponse(['error' => 'An error has occured']);
    }

    #[Route('/delete/{id}', name: 'option_delete', methods: ['DELETE'])]
    public function delete($id, OptionRepository $optionRepository, EntityManagerInterface $entityManager): JsonResponse
    {
        $option = $optionRepository->find($id);
        if (!$option) {
            throw new NotFoundHttpException('Option not found');
        }

        $entityManager->remove($option);
        $entityManager->flush();

        return new JsonResponse(['status' => 'The Option has been deleted']);
    }
}
